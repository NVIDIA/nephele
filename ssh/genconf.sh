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

SSH_USER=nvidia
SSH_CONFIG=config
SSH_PRIVKEY=id_rsa
SSH_KNOWN_HOSTS=known_hosts
SSH_HOST_PUBKEY=host_ed25519.pub

rm -f "${SSH_CONFIG}" "${SSH_KNOWN_HOSTS}"

cat > "${SSH_CONFIG}" << EOF
Host *
  User ${SSH_USER}
  PasswordAuthentication no
  CheckHostIP yes
  StrictHostKeyChecking yes
  IdentityFile ${PWD}/${SSH_PRIVKEY}
  UserKnownHostsFile ${PWD}/${SSH_KNOWN_HOSTS}

EOF

while read type x hosts; do
    [ -z "${hosts}" ] && continue

    readarray -d, -t ips < <(printf "${hosts}")

    for i in "${!ips[@]}"; do
        printf "Host %s-%04d\n" "${type}" "${i}"
        if [ "${type}" != "login" ]; then
            printf "  ProxyJump login-0000\n"
        fi
        printf "  Hostname %s\n\n" "${ips[$i]}"
    done >> "${SSH_CONFIG}"

    printf "%s %s\n" "${hosts}" "$(< ${SSH_HOST_PUBKEY})" >> "${SSH_KNOWN_HOSTS}"
done
