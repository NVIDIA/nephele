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

resource "aws_launch_template" "default" {
  name          = var.name
  instance_type = var.type

  dynamic "instance_market_options" {
    for_each = var.preemptible ? ["spot"] : []
    content {
      market_type = instance_market_options.value
    }
  }
  instance_initiated_shutdown_behavior = "terminate"

  user_data = var.config
  image_id  = var.vmi.id


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 2000
      delete_on_termination = true
    }
  }
  ebs_optimized = true

  network_interfaces {
    device_index                = 0
    network_card_index          = 0
    associate_public_ip_address = var.public
    interface_type              = var.efa > 0 ? "efa" : "interface"
    subnet_id                   = var.subnet.id
    delete_on_termination       = true
    security_groups             = [var.firewall.id]
  }
  dynamic "network_interfaces" {
    for_each = var.efa > 1 ? range(1, var.efa) : []
    content {
      device_index                = network_interfaces.value
      network_card_index          = network_interfaces.value
      interface_type              = "efa"
      subnet_id                   = var.subnet.id
      delete_on_termination       = true
      security_groups             = [var.firewall.id]
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = var.name
      Cluster = var.cluster_id
    }
  }
}

resource "aws_autoscaling_group" "default" {
  count               = var.replicas > 0 ? 1 : 0
  name                = var.name
  vpc_zone_identifier = [var.subnet.id]
  placement_group     = var.placement != null ? var.placement.name : null
  max_size            = var.replicas
  min_size            = var.replicas
  desired_capacity    = var.replicas

  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
  tag {
    key                 = "Cluster"
    value               = var.cluster_id
    propagate_at_launch = true
  }
}
