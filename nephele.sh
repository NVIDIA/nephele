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

source nephele.conf

for cmd in enroot terraform ansible; do
    command -v "${cmd}" > /dev/null || { echo "Could not find command: ${cmd}"; exit 1; } >&2
done

init() {
    pushd ssh
    echo "Generating SSH keys..."
    ./genkeys.sh
    popd

    pushd terraform
    echo "Initializing terraform..."
    terraform init "${CLOUD_PROVIDER}"
    popd

    pushd ansible
    echo "Initializing ansible..."
    ansible-galaxy collection install -r requirements.yml
    ansible-galaxy role install -r requirements.yml

    echo "Creating password..."
    read -s -r -e -p "Enter a new password for ansible vault: "
    echo "${REPLY}" > .vault-password
    popd

    echo "Building packages..."
    make -C packages all mostlyclean

    echo "Done"
}

create() {
    export TF_VAR_region="${CLOUD_REGION}"
    export TF_VAR_replicas="{ x4v100 = ${REPLICAS_x4v100} }" # FIXME doesn't seem to work for some reason

    pushd terraform
    echo "Creating ${CLOUD_PROVIDER} cluster..."
    terraform apply -parallelism=${TF_threads} -var replicas="${TF_VAR_replicas}" "${CLOUD_PROVIDER}"

    echo "Generating SSH configuration..."
    terraform output | ../ssh/genconf.sh

    echo "Generating ansible configuration..."
    terraform output | ../ansible/geninv.sh
    popd

    pushd ansible
    echo "Waiting for instances..."
    while ! ansible all -a "cloud-init status --wait"; do echo "Retrying in 5s"; sleep 5; done
    sleep 10 # wait for the reboot
    ansible all -m wait_for_connection

    echo "Uploading packages..."
    ansible all --list-hosts | sed 1d | xargs -P0 -n1 -i scp -F ../ssh/config ../packages/*.deb {}:/var/tmp

    echo "Provisioning instances..."
    ansible-playbook playbooks/bootstrap.yml
    ansible-playbook playbooks/nvidia.yml
    ansible-playbook playbooks/mellanox.yml
    ansible-playbook playbooks/containers.yml
    ansible-playbook playbooks/slurm.yml
    popd

    echo "Done"
}

connect() {
    exec ssh -F ssh/config login-0000
}

destroy() {
    pushd terraform
    echo "Destroying ${CLOUD_PROVIDER} cluster..."
    terraform destroy -parallelism=${TF_threads} "${CLOUD_PROVIDER}"
    popd

    echo "Done"
}

case "${1-}" in
    init|create|connect|destroy) "$1" ;;
    *) echo "Usage: ${0##*/} init|create|connect|destroy" ;;
esac
