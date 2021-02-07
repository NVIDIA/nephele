#! /bin/bash

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

set -eu
cd $(dirname "$(readlink -f "$0")")

ANSIBLE_INVENTORY=inventory

rm -f "${ANSIBLE_INVENTORY}"

declare -A groups

while read type x hosts; do
    readarray -d, -t ips < <(printf "${hosts}")

    if [[ "${type}" == *-* ]]; then
        groups[${type%%-*}]+=" ${type#*-} "
    fi
    printf "[%s]\n" "${type#*-}"
    if [ ${#ips[@]} -gt 0 ]; then
        printf "%s-[0000:%04d]\n" "${type}" $((${#ips[@]} - 1))
    fi
    printf "\n"
done >> "${ANSIBLE_INVENTORY}"

for group in "${!groups[@]}"; do
    printf "[%s:children]\n" "${group}"
    printf "%s\n" ${groups["${group}"]}
done >> "${ANSIBLE_INVENTORY}"


cat << EOF >> "${ANSIBLE_INVENTORY}"

### SLURM ###

[slurm_controller:children]
login

[slurm_client:children]
login

[slurm_compute:children]
compute
EOF
