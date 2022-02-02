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

set -eu

unmount() {
    if ! read fs opts src dst < <(findmnt -t tmpfs -f -n -r -o FSTYPE,OPTIONS,SOURCE,TARGET $1); then
        return
    fi
    if ! umount -R "${dst}"; then
        if [ -e "${dst}" ]; then
            printf "%s: failed to unmount %s, falling back to deletion and detach\n" "$0" "${dst}" >&2
            find "${dst}" -mindepth 1 -delete || true
            umount -l "${dst}"
        fi
    fi
    if [ -n "${2-}" ]; then
        mount -t "${fs}" -o "${opts}" "${src}" "${dst}"
    fi
}

unmount "/tmp" and_remount
unmount "/dev/shm" and_remount

unmount "/run/user/${SLURM_JOB_UID}"
rm -f -d "/run/user/${SLURM_JOB_UID}"

exit 0
