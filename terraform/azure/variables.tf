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

variable "region" {
  description = "Region for the cluster"
  type        = string
  default     = null
}

variable "subnet" {
  description = "Address prefix to use for the VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "preemptible" {
  description = "Use preemptible (spot) instances"
  type        = bool
  default     = false
}

variable "ssh" {
  description = "SSH configuration for login"
  type        = object({
    user         = string
    pubkey       = string
    privkey_host = string
    pubkey_host  = string
  })
  default     = null
}

variable "replicas" {
  description = "Number of instance replicas"
  type        = object({
    x4v100 = number
    x8a100 = number
  })
  default     = null
}
