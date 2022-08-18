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

variable "region" {
  description = "Region for the cluster"
  type        = string
  default     = null
}

variable "zone" {
  description = "Availability zone for the cluster"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "Address prefix to use for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "preemptible" {
  description = "Use preemptible (spot) instances"
  type        = bool
  default     = false
}

variable "ssh" {
  description = "SSH configuration"
  type        = object({
    user         = string
    privkey      = string
    pubkey       = string
    privkey_host = string
    pubkey_host  = string
    known_hosts  = string
    config       = string
  })
  default     = null
}

variable "ansible" {
  description = "Ansible configuration"
  type        = object({
    inventory = string
  })
  default     = null
}

variable "replicas" {
  description = "Number of instance replicas"
  type        = object({
    x4v100     = number
    x8a100_40g = number
    x8a100_80g = number
  })
  default     = null
}
