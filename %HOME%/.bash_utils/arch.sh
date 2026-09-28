# Copyright (c) 2026 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home
# Distributed under the MIT License.

pacman_upgrade() (
    _bash_func_prelude
    sudo pacman -Syu --noconfirm
)

pacman_cleanup() (
    _bash_func_prelude

    local output
    output="$( pacman -Qqdt )" || true
    if [ -n "$output" ]; then
        echo "$output" | sudo pacman -Rcsn --noconfirm -
    fi
)

yay_opts='--noconfirm --needed --cleanafter --removemake'

yay_upgrade() (
    _bash_func_prelude
    yay -Syua $yay_opts
)

yay_install() (
    _bash_func_prelude
    yay -Sya $yay_opts "$@"
)

yay_cleanup() (
    _bash_func_prelude
    yay -Sca --noconfirm
)

arch_upgrade() (
    _bash_func_prelude

    echo ======================================================================
    pacman_upgrade
    echo ======================================================================
    yay_upgrade
    echo ======================================================================

    local reboot_timeout=10
    echo "Rebooting in $reboot_timeout seconds..."
    sleep "$reboot_timeout"
    reboot
)

arch_cleanup() (
    _bash_func_prelude

    echo ======================================================================
    pacman_cleanup
    echo ======================================================================
    yay_cleanup
    echo ======================================================================
)
