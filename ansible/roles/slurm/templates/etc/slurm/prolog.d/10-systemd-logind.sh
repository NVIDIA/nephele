#! /usr/bin/env bash

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

# TODO session_id, locale, timezone, etc

set -eu

runtime_dir="/run/user/${SLURM_JOB_UID}"

if [ ! -d "${runtime_dir}" ]; then
    mkdir -p "${runtime_dir}"
fi
if ! findmnt "${runtime_dir}" > /dev/null; then
    mount -t tmpfs -o "rw,nosuid,nodev,relatime,mode=0700,uid=${SLURM_JOB_UID},gid=${SLURM_JOB_GID}" tmpfs "${runtime_dir}"
fi

printf "export XDG_RUNTIME_DIR=%s" "${runtime_dir}\n"

exit 0
