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

resource "azurerm_public_ip" "default" {
  name                = "${var.prefix}-${count.index}-pip"
  count               = var.public ? var.replicas : 0
  resource_group_name = var.region.name
  location            = var.region.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "default" {
  name                      = "${var.prefix}-${count.index}-nic"
  count                     = var.replicas
  resource_group_name       = var.region.name
  location                  = var.region.location

  # Not supported on IB instances
  #enable_accelerated_networking = true

  ip_configuration {
    name                          = "${var.prefix}-${count.index}-ip"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public ? azurerm_public_ip.default[count.index].id : null
  }
}

resource "azurerm_network_interface_security_group_association" "default" {
  count                     = var.public ? var.replicas : 0
  network_interface_id      = azurerm_network_interface.default[count.index].id
  network_security_group_id = var.firewall.id
}

resource "azurerm_linux_virtual_machine" "default" {
  name                         = "${var.prefix}-${count.index}"
  resource_group_name          = var.region.name
  location                     = var.region.location
  size                         = var.type
  count                        = var.replicas
  proximity_placement_group_id = var.group.id
  priority                     = var.preemptible ? "Spot" : "Regular"
  eviction_policy              = var.preemptible ? "Delete" : null

  # Not supported on GPU instances
  #dedicated_host_id =

  # Required even though we rely on cloud config
  admin_username             = var.ssh.user
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
    name                 = "${var.prefix}-${count.index}-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadOnly"

    # Not supported on GPU instances
    #diff_disk_settings {
    #  option = "Local"
    #}
  }

  network_interface_ids = [
    azurerm_network_interface.default[count.index].id
  ]
}
