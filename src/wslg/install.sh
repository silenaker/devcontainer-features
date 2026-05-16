#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if [ -r /etc/os-release ]; then
    . /etc/os-release
fi

if [ "${ID:-}" != "ubuntu" ]; then
    exit 0
fi

apt_get_update() {
    if [ -z "${_apt_updated:-}" ]; then
        apt-get update
        _apt_updated=1
    fi
}

apt_get_install() {
    apt_get_update
    apt-get install -y --no-install-recommends "$@"
}

if [ "${USEKISAKPPA:-}" = "true" ] && [ "${ID:-}" = "ubuntu" ] && [ -n "${VERSION_CODENAME:-}" ]; then
    apt_get_install ca-certificates curl gnupg
    mkdir -p /etc/apt/keyrings

    curl -fsSL \
        "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xF63F0F2B90935439" |
        gpg --dearmor --batch --yes -o /etc/apt/keyrings/kisak.gpg

    chmod 644 /etc/apt/keyrings/kisak.gpg

    echo \
        "deb [signed-by=/etc/apt/keyrings/kisak.gpg] https://ppa.launchpadcontent.net/kisak/kisak-mesa/ubuntu ${VERSION_CODENAME} main" \
        >/etc/apt/sources.list.d/kisak.list

    if apt-get update; then
        _apt_updated=1
    else
        echo "Failed to update from the kisak Mesa PPA for ${VERSION_CODENAME}; falling back to distribution packages."
        rm -f /etc/apt/sources.list.d/kisak.list /etc/apt/keyrings/kisak.gpg
        _apt_updated=
    fi
fi

apt_get_install \
    mesa-utils \
    mesa-vulkan-drivers \
    vulkan-tools

apt-get clean
rm -rf /var/lib/apt/lists/*
