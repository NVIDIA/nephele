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

data "azurerm_platform_image" "ubuntu_2004" {
  location  = azurerm_resource_group.default.location
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts-gen2"
}

data "template_cloudinit_config" "ubuntu_2004" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.root}/../config/ubuntu.yml", {
      ssh_user         = var.ssh.user
      ssh_pubkey       = jsonencode(file(var.ssh.pubkey))
      ssh_privkey_host = jsonencode(file(var.ssh.privkey_host))
      ssh_pubkey_host  = jsonencode(file(var.ssh.pubkey_host))
    })
  }
}

data "azurerm_platform_image" "ubuntu_1804" {
  location  = azurerm_resource_group.default.location
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18_04-lts-gen2"
}

data "template_cloudinit_config" "ubuntu_1804" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.root}/../config/ubuntu.yml", {
      ssh_user         = var.ssh.user
      ssh_pubkey       = jsonencode(file(var.ssh.pubkey))
      ssh_privkey_host = jsonencode(file(var.ssh.privkey_host))
      ssh_pubkey_host  = jsonencode(file(var.ssh.pubkey_host))
    })
  }
}
