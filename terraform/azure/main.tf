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

terraform {
  required_version = "~> 1.0"
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "~> 2.41"
    }
  }
}

provider "azure" {
  features {}
}

resource "random_pet" "generator" {
  length = 1
}

locals {
  cluster_id = "nephele-${random_pet.generator.id}"
}

resource "azurerm_resource_group" "default" {
  name     = "${local.cluster_id}-group"
  location = var.region

  timeouts {
    read   = "15m"
    create = "3h"
    update = "3h"
    delete = "3h"
  }
}
