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

data "aws_instances" "all" {
  # WAR https://github.com/hashicorp/terraform/issues/16380
  count = var.replicas > 0 ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${var.name}*"]
  }
  filter {
    name   = "instance-type"
    values = [var.type]
  }
  instance_state_names = ["running"]

  depends_on = [
    aws_autoscaling_group.default
  ]
}

output "public_ips" {
  value = var.replicas > 0 ? join(",", data.aws_instances.all[0].public_ips) : ""
}

output "private_ips" {
  value = var.replicas > 0 ? join(",", data.aws_instances.all[0].private_ips) : ""
}
