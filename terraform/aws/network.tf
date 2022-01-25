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

resource "aws_vpc" "default" {
  cidr_block        = var.vpc_cidr
  # FIXME: Not supported
  #instance_tenancy = "dedicated"

  tags = {
    Name = "${local.cluster_id}-vpc"
  }
}

data "aws_availability_zone" "default" {
  count = var.zone != null ? 1 : 0

  state = "available"
  name  = var.zone
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.default.id
  availability_zone = var.zone != null ? data.aws_availability_zone.default[0].name : null
  cidr_block        = var.subnet_cidr.public

  tags = {
    Name = "${local.cluster_id}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.default.id
  availability_zone = var.zone != null ? data.aws_availability_zone.default[0].name : null
  cidr_block        = var.subnet_cidr.private

  tags = {
    Name = "${local.cluster_id}-private-subnet"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${local.cluster_id}-gateway"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.default.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "${local.cluster_id}-public-route"
  }
}

resource "aws_eip" "default" {
  vpc = true

  tags = {
    Name = "${local.cluster_id}-eip"
  }
}

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.default.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${local.cluster_id}-nat"
  }

  depends_on = [aws_internet_gateway.default]
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.default.id
  }

  tags = {
    Name = "${local.cluster_id}-private-route"
  }
}

resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.default.id
}
