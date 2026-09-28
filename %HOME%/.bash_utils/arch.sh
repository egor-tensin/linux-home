# Copyright (c) 2026 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home
# Distributed under the MIT License.

yay_upgrade() (
    _bash_func_prelude
    yay -Syua --noconfirm --needed --cleanafter
)

yay_install() (
    _bash_func_prelude
    yay -Sy --noconfirm --needed --cleanafter "$@"
)

arch_upgrade() (
    _bash_func_prelude

    echo ======================================================================
    sudo pacman -Syu --noconfirm
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
    local output
    output="$( pacman -Qqdt )" || true
    if [ -n "$output" ]; then
        echo "$output" | sudo pacman -Rcsn --noconfirm -
    fi
    echo ======================================================================
    yay -Sca --noconfirm
    echo ======================================================================
)
