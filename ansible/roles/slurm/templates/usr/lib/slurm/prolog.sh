#! /usr/bin/env bash

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

shopt -s nullglob

exit_code=0
start_time=$(date +%s)

runparts() {
    for part in $1/*; do
        [ -x "${part}" ] || continue
        if ! "${part}"; then
            printf "%s exited with return code %d\n" "${part}" "$?" >&2
            exit_code=1
        fi
    done
}

logger -s -t slurm-prolog "START user=${SLURM_JOB_USER} job=${SLURM_JOB_ID}"
runparts {{ _sysconf_dir }}/prolog.d 2> >(logger -e -s -t slurm-prolog)
logger -s -t slurm-prolog "END user=${SLURM_JOB_USER} job=${SLURM_JOB_ID} after $(( $(date +%s) - start_time )) seconds"

exit "${exit_code}"
