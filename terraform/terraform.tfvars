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

# Azure
#region  = "West US 2"
#zone    = 1

# GCP
#region  = "us-west1"
#zone    = "us-west1-a"

# AWS
#region  = "us-west-2"
#zone    = "us-west-2a"

ssh = {
  user         = "nvidia"
  privkey      = "../../ssh/id_rsa"
  pubkey       = "../../ssh/id_rsa.pub"
  privkey_host = "../../ssh/host_ed25519"
  pubkey_host  = "../../ssh/host_ed25519.pub"
  known_hosts  = "../../ssh/known_hosts"
  config       = "../../ssh/config"
}

ansible = {
  inventory      = "../../ansible/inventory"
}

replicas = {
  x4v100 = 0
  x8a100 = 0
}
