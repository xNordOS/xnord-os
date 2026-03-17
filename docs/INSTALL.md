# x-Nord OS Installation Guide

## Requirements

- **RAM:** 8 GB minimum (16 GB+ recommended for AI assistant)
- **Storage:** 30 GB minimum
- **Architecture:** x86_64 (amd64)

## Creating a Bootable USB

### Linux

```bash
# Replace /dev/sdX with your USB device (e.g. /dev/sdb)
sudo dd if=xnord-os-1.0-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### macOS

```bash
# Replace /dev/diskN with your USB device
sudo dd if=xnord-os-1.0-amd64.iso of=/dev/rdiskN bs=4m
```

### Windows

Use [Rufus](https://rufus.ie/) or [Balena Etcher](https://balena.io/etcher/) to write the ISO to a USB drive.

## Installation Steps

1. **Boot** from the USB drive
2. **Select** "Try or Install x-Nord OS"
3. **Launch** the installer from the desktop (Calamares)
4. **Follow** the 5 steps:
   - Welcome (language, keyboard)
   - Partition (choose disk, auto or manual)
   - Users (username, password)
   - Summary (review)
   - Install (copy system)
5. **Reboot** when prompted and remove the USB

## First Boot

- **AI Assistant:** On first use, you may be prompted to download the Llama 3.2 3B model (~2GB). This runs entirely on your device.
- **Flatpak:** Open Discover to browse and install apps from the curated store.
