#!/bin/bash
# Install build dependencies for x-Nord OS ISO (Ubuntu 24.04)
# Contact: hello@xnord.co.uk

set -e

echo "Installing x-Nord OS build dependencies..."

sudo apt-get update
sudo apt-get install -y \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    rsync \
    wget \
    curl \
    ca-certificates \
    systemd-container \
    cpio

# Optional: genisoimage (alternative to xorriso for some steps)
sudo apt-get install -y genisoimage 2>/dev/null || true

echo "Dependencies installed."
