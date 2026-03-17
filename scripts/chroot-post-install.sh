#!/bin/bash
# Run inside Cubic chroot to install packages and configure system

set -e

# Install required packages
apt-get update
apt-get install -y \
    calamares \
    flatpak \
    plasma-discover \
    plasma-discover-flatpak-backend \
    || true

# Install Ollama (if available) or prepare for manual install
if command -v ollama &>/dev/null; then
    systemctl enable ollama
else
    # Ollama will be installed via install script; create placeholder
    mkdir -p /usr/bin
fi

# Set Plymouth theme
if [ -f /usr/share/plymouth/themes/xnord/xnord.plymouth ]; then
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
        /usr/share/plymouth/themes/xnord/xnord.plymouth 100
    update-alternatives --set default.plymouth /usr/share/plymouth/themes/xnord/xnord.plymouth
fi

# SDDM theme configured via copied xnord.conf

# Add Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Update initramfs for Plymouth
update-initramfs -u -k all 2>/dev/null || true

exit 0
