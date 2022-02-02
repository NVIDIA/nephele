# Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
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

# WAR: https://github.com/hashicorp/terraform-provider-azurerm/issues/7333
data "external" "public_ips" {
  count = var.replicas > 0 ? 1 : 0

  program = ["az", "vmss", "list-instance-public-ips", "-g", var.group.name, "--name", azurerm_linux_virtual_machine_scale_set.default[0].name, "--query", "{addrs: join(',', [].ipAddress)}"]
}

# WAR: https://github.com/hashicorp/terraform-provider-azurerm/issues/7333
data "external" "private_ips" {
  count = var.replicas > 0 ? 1 : 0

  program = ["az", "vmss", "nic", "list", "-g", var.group.name, "--vmss-name", azurerm_linux_virtual_machine_scale_set.default[0].name, "--query", "{addrs: join(',', [].ipConfigurations[0].privateIpAddress)}"]
}

output "public_ips" {
  value = var.replicas > 0 ? data.external.public_ips[0].result.addrs : ""
}

output "private_ips" {
  value = var.replicas > 0 ? data.external.private_ips[0].result.addrs : ""
}
