# Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "azurerm_linux_virtual_machine_scale_set" "default" {
  count                        = var.replicas > 0 ? 1 : 0
  name                         = var.name
  resource_group_name          = var.group.name
  location                     = var.group.location
  sku                          = var.type
  instances                    = var.replicas
  zones                        = var.zone != null ? [tonumber(var.zone)] : []
  proximity_placement_group_id = var.placement != null ? var.placement.id : null
  priority                     = var.preemptible ? "Spot" : "Regular"
  eviction_policy              = var.preemptible ? "Delete" : null
  overprovision                = false

  # Not supported on GPU instances
  #dedicated_host_id =

  # Required even though we rely on cloud config
  admin_username = var.ssh.user
  admin_ssh_key {
    username   = var.ssh.user
    public_key = file(var.ssh.pubkey)
  }

  custom_data = var.config

  # WAR: https://github.com/terraform-providers/terraform-provider-azurerm/issues/6745
  #source_image_id = var.vmi.id
  source_image_reference {
    publisher = var.vmi.publisher
    offer     = var.vmi.offer
    sku       = var.vmi.sku
    version   = var.vmi.version
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadOnly"
    disk_size_gb         = "2000"

    # Not supported on GPU instances
    #diff_disk_settings {
    #  option = "Local"
    #}
  }

  network_interface {
    name                      = "${var.name}-nic"
    network_security_group_id = var.firewall.id
    primary                   = true

    # Not supported on IB instances
    #enable_accelerated_networking = true

    ip_configuration {
      name      = "${var.name}-ip"
      subnet_id = var.subnet.id

      dynamic "public_ip_address" {
        for_each = var.public ? ["${var.name}-pip"] : []
        content {
          name = public_ip_address.value
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      network_interface[0].ip_configuration[0].primary
    ]
  }
}
