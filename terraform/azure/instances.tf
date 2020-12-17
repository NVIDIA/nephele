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

resource "azurerm_proximity_placement_group" "default" {
  name                = "${local.cluster_id}-placement"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

module "instances_login" {
  source = "./instance"

  prefix      = "${local.cluster_id}-login"
  type        = "Standard_DS4_v2"
  replicas    = 1
  public      = true
  preemptible = false

  ssh         = var.ssh
  vmi         = data.azurerm_platform_image.ubuntu_2004
  config      = data.template_cloudinit_config.ubuntu_2004.rendered
  region      = azurerm_resource_group.default
  group       = azurerm_proximity_placement_group.default
  subnet      = azurerm_subnet.default
  firewall    = azurerm_network_security_group.default
}

module "instances_x4v100" {
  source = "./instance"

  prefix      = "${local.cluster_id}-x4v100"
  type        = "Standard_NC24rs_v3"
  replicas    = var.replicas.x4v100
  public      = false
  preemptible = var.preemptible

  ssh         = var.ssh
  vmi         = data.azurerm_platform_image.ubuntu_2004
  config      = data.template_cloudinit_config.ubuntu_2004.rendered
  region      = azurerm_resource_group.default
  group       = azurerm_proximity_placement_group.default
  subnet      = azurerm_subnet.default
  firewall    = azurerm_network_security_group.default
}

module "instances_x8a100" {
  source = "./instance"

  prefix      = "${local.cluster_id}-x8a100"
  type        = "Standard_ND96asr_v4"
  replicas    = var.replicas.x8a100
  public      = false
  preemptible = var.preemptible

  ssh         = var.ssh
  vmi         = data.azurerm_platform_image.ubuntu_2004
  config      = data.template_cloudinit_config.ubuntu_2004.rendered
  region      = azurerm_resource_group.default
  group       = azurerm_proximity_placement_group.default
  subnet      = azurerm_subnet.default
  firewall    = azurerm_network_security_group.default
}
