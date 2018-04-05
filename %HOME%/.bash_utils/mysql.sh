#!/usr/bin/env bash

# Copyright (c) 2018 Egor Tensin <Egor.Tensin@gmail.com>
# This file is part of the "Linux/Cygwin environment" project.
# For details, see https://github.com/egor-tensin/linux-home.
# Distributed under the MIT License.

_runsql_check_var() (
    set -o errexit -o nounset -o pipefail

    local prefix="${FUNCNAME[0]}"
    [ "${#FUNCNAME[@]}" -gt 1 ] && prefix="${FUNCNAME[1]}"

    local var_name
    for var_name; do
        if [ -z "${!var_name:+x}" ]; then
            echo "$prefix: $var_name is not set" >&2
            return 1
        fi
    done
)

runsql() (
    set -o errexit -o nounset -o pipefail

    _runsql_check_var MYSQL_USER MYSQL_PASSWORD MYSQL_HOST
    local MYSQL_PORT="${MYSQL_PORT:-3306}"

    local -a statement_list
    local stmt
    for stmt; do
        statement_list+=(-e "$stmt")
    done

    mysql \
        --user="$MYSQL_USER" \
        --password="$MYSQL_PASSWORD" \
        --host="$MYSQL_HOST" \
        --port="$MYSQL_PORT" \
        "${statement_list[@]}"
)
