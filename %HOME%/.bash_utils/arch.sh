# Copyright (c) 2026 Egor Tensin <egor@tensin.name>
# This file is part of the "linux-home" project.
# For details, see https://github.com/egor-tensin/linux-home
# Distributed under the MIT License.

arch_upgrade() (
    _bash_func_prelude

    echo ======================================================================
    sudo pacman -Syu --noconfirm
    echo ======================================================================
    yay -Syua --noconfirm --needed --cleanafter
    echo ======================================================================

    local reboot_timeout=10
    echo "Rebooting in $reboot_timeout seconds..."
    sleep "$reboot_timeout"
    reboot
)

arch_cleanup() (
    _bash_func_prelude

    echo ======================================================================
    pacman -Qqdt | sudo pacman -Rcsn --noconfirm -
    echo ======================================================================
    yay -Sca --noconfirm
    echo ======================================================================
)

arch_yay_install() (
    _bash_func_prelude
    yay -Sy --noconfirm --needed --cleanafter "$@"
)
