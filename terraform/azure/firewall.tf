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

resource "azurerm_network_security_group" "default" {
  name                = "${local.cluster_id}-firewall"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

# See default Azure security group rules:
# https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview#default-security-rules

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "${local.cluster_id}-allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  resource_group_name         = azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name
}
