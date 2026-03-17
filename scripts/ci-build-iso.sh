#!/bin/bash
# Headless x-Nord OS ISO build for CI (no Cubic GUI)
# Extracts Kubuntu ISO, applies customizations, repacks
# Contact: hello@xnord.co.uk

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
WORK_DIR="${WORK_DIR:-/tmp/xnord-build}"
BASE_ISO="${1:-}"

# Kubuntu 24.04 download URL
KUBUNTU_URL="https://cdimage.ubuntu.com/kubuntu/releases/24.04/release/kubuntu-24.04.4-desktop-amd64.iso"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Download base ISO if not provided
if [ -z "$BASE_ISO" ] || [ ! -f "$BASE_ISO" ]; then
    echo "Downloading Kubuntu 24.04..."
    BASE_ISO="$WORK_DIR/kubuntu-24.04.4-desktop-amd64.iso"
    wget -q --show-progress -O "$BASE_ISO" "$KUBUNTU_URL" || {
        echo "Download failed. Use: $0 /path/to/kubuntu-24.04-desktop-amd64.iso"
        exit 1
    }
fi

echo "=== x-Nord OS CI Build ==="
echo "Base: $BASE_ISO"
echo "Work: $WORK_DIR"

# Create directories
mkdir -p iso squash upper work chroot newiso
sudo rm -rf iso/* upper/* work/* chroot/* newiso/* 2>/dev/null || true

# Mount ISO
echo "Mounting ISO..."
sudo mount -o loop,ro "$BASE_ISO" iso

# Mount squashfs
echo "Mounting filesystem.squashfs..."
sudo mount -t squashfs -o ro iso/casper/filesystem.squashfs squash

# Overlay for writable layer (upper + work must be empty)
echo "Creating overlay..."
sudo mount -t overlay overlay -o lowerdir=squash,upperdir=upper,workdir=work chroot

# Mount binds for chroot
sudo mount --bind /dev chroot/dev
sudo mount --bind /run chroot/run
sudo mount -t proc none chroot/proc
sudo mount -t sysfs none chroot/sys
sudo mount -t devpts none chroot/dev/pts
sudo cp /etc/resolv.conf chroot/etc/resolv.conf 2>/dev/null || true

# Run x-Nord install
echo "Applying x-Nord customizations..."
sudo "$SCRIPT_DIR/install-to-chroot.sh" "$(pwd)/chroot"

# Unmount binds
sudo umount chroot/dev/pts chroot/dev chroot/run chroot/proc chroot/sys 2>/dev/null || true

# Copy ISO contents (excluding squashfs) to newiso
echo "Preparing new ISO..."
rsync -a --exclude='casper/filesystem.squashfs' --exclude='casper/filesystem.size' iso/ newiso/

# Create new squashfs from overlay (chroot contains the merged view)
echo "Creating new filesystem.squashfs (this takes several minutes)..."
sudo mksquashfs chroot newiso/casper/filesystem.squashfs -noappend -comp xz -Xbcj x86

# Update filesystem.size
printf '%s' "$(sudo du -sx --block-size=1 chroot | cut -f1)" | sudo tee newiso/casper/filesystem.size > /dev/null

# Unmount overlay and squash
sudo umount chroot
sudo umount squash
sudo umount iso

# Build ISO with xorriso (detect boot structure from original)
echo "Building final ISO..."
OUTPUT_ISO="$PROJECT_ROOT/xnord-os-1.0-amd64.iso"
cd "$WORK_DIR/newiso"

# Kubuntu/Ubuntu 24.04: detect boot images
BOOT_IMG=""
EFI_IMG=""
[ -f boot/grub/i386-pc/eltorito.img ] && BOOT_IMG="boot/grub/i386-pc/eltorito.img"
[ -f isolinux/isolinux.bin ] && BOOT_IMG="isolinux/isolinux.bin"
[ -f EFI/boot/bootx64.efi ] && EFI_IMG="EFI/boot/bootx64.efi"
[ -f boot/grub/efi.img ] && EFI_IMG="boot/grub/efi.img"

if [ -n "$BOOT_IMG" ]; then
    XORRISO_EFI=""
    [ -n "$EFI_IMG" ] && XORRISO_EFI="-eltorito-alt-boot -e $EFI_IMG -no-emul-boot"
    xorriso -as mkisofs -r -V "x-Nord OS 1.0" -o "$OUTPUT_ISO" -J -l -cache-inodes \
        -b "$BOOT_IMG" -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table \
        $XORRISO_EFI -isohybrid-gpt-basdat .
else
    xorriso -as mkisofs -r -V "x-Nord OS 1.0" -o "$OUTPUT_ISO" -J -l .
fi

echo "Build complete: $OUTPUT_ISO"
