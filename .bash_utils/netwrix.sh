#!/usr/bin/env bash

# Copyright (c) 2016 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Cygwin configuration files" project.
# For details, see https://github.com/egor-tensin/cygwin-home.
# Distributed under the MIT License.

source .bash_utils/git.sh  || return
source .bash_utils/text.sh || return

export nwx_host=172.28.10.2
export nwx_dev2=172.28.19.60
export nwx_dev3=172.28.19.61

lint_webapi() (
    set -o errexit -o nounset -o pipefail

    local root_dir='/cygdrive/c/Netwrix Auditor/CurrentVersion-AuditCore-Dev/AuditCore/Sources'

    local -a paths
    local path

    cd "$root_dir/Configuration"
    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( find . -type f -\( -iname 'WebAPI*.acinc' -o -iname 'WebAPI*.acconf' -\) -print0 )

    cd "$root_dir/Subsystems/PublicAPI"
    while IFS= read -d '' -r path; do
        paths+=("$path")
    done < <( find . -type f -\( -iname '*.cpp' -o -iname '*.h' -\) -print0 )

    doslint "${paths[@]+"${paths[@]}"}"
)

backup_repo_nwx() {
    backup_repo '//spbfs02/P/Personal/Egor Tensin'
}