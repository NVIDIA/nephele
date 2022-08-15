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

output "login" {
  value = module.instances_login.public_ips
}

output "x4v100" {
  value = module.instances_x4v100.private_ips
}

output "x8v100" {
  value = module.instances_x8v100.private_ips
}

output "x8a100_40g" {
  value = module.instances_x8a100_40g.private_ips
}

resource "local_file" "ansible_inventory" {
  filename = var.ansible.inventory
  content  = templatefile("${var.ansible.inventory}.tf", {
    login      = module.instances_login.public_ips,
    x4v100     = module.instances_x4v100.private_ips,
    x8v100     = module.instances_x8v100.private_ips,
    x8a100_40g = module.instances_x8a100_40g.private_ips,
  })
}

resource "local_file" "ssh_known_hosts" {
  filename = var.ssh.known_hosts
  content  = templatefile("${var.ssh.known_hosts}.tf", {
    pubkey_host = var.ssh.pubkey_host,
    login       = module.instances_login.public_ips,
    x4v100      = module.instances_x4v100.private_ips,
    x8v100      = module.instances_x8v100.private_ips,
    x8a100_40g  = module.instances_x8a100_40g.private_ips,
  })
}

resource "local_file" "ssh_config" {
  filename = var.ssh.config
  content  = templatefile("${var.ssh.config}.tf", {
    user        = var.ssh.user
    privkey     = var.ssh.privkey,
    known_hosts = var.ssh.known_hosts,
    login       = module.instances_login.public_ips,
    x4v100      = module.instances_x4v100.private_ips,
    x8v100      = module.instances_x8v100.private_ips,
    x8a100_40g  = module.instances_x8a100_40g.private_ips,
  })
}
