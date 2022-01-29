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

resource "aws_placement_group" "default" {
  name     = "${local.cluster_id}-placement"
  strategy = "cluster"

  tags = {
    Name = "${local.cluster_id}-placement"
  }
}

module "instances_login" {
  source = "./instance"

  cluster_id  = local.cluster_id
  name        = "${local.cluster_id}-login"
  type        = "m6i.4xlarge"
  efa         = 0
  replicas    = 1
  public      = true
  preemptible = false

  vmi         = data.aws_ami.ubuntu_2004
  config      = data.template_cloudinit_config.ubuntu_2004.rendered
  placement   = null
  subnet      = aws_subnet.public
  firewall    = aws_security_group.default
}

module "instances_x4v100" {
  source = "./instance"

  cluster_id  = local.cluster_id
  name        = "${local.cluster_id}-x4v100"
  efa         = 0
  type        = "p3.8xlarge"
  replicas    = var.replicas.x4v100
  public      = false
  preemptible = var.preemptible

  vmi         = data.aws_ami.ubuntu_2004
  config      = data.template_cloudinit_config.ubuntu_2004.rendered
  placement   = aws_placement_group.default
  subnet      = aws_subnet.private
  firewall    = aws_security_group.default
}

module "instances_x8v100" {
  source = "./instance"

  cluster_id  = local.cluster_id
  name        = "${local.cluster_id}-x8v100"
  efa         = 1
  type        = "p3dn.24xlarge"
  replicas    = var.replicas.x8v100
  public      = false
  preemptible = var.preemptible

  vmi         = data.aws_ami.ubuntu_2004
  config      = data.template_cloudinit_config.ubuntu_2004.rendered
  placement   = aws_placement_group.default
  subnet      = aws_subnet.private
  firewall    = aws_security_group.default
}

module "instances_x8a100" {
  source = "./instance"

  cluster_id  = local.cluster_id
  name        = "${local.cluster_id}-x8a100"
  efa         = 4
  type        = "p4d.24xlarge"
  replicas    = var.replicas.x8a100
  public      = false
  preemptible = var.preemptible

  vmi         = data.aws_ami.ubuntu_2004
  config      = data.template_cloudinit_config.ubuntu_2004.rendered
  placement   = aws_placement_group.default
  subnet      = aws_subnet.private
  firewall    = aws_security_group.default
}
