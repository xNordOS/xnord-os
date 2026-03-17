#!/bin/bash
# Headless x-Nord OS ISO build for CI (no Cubic GUI)
# Extracts Kubuntu ISO, applies customizations, repacks
# Builds hybrid ISO for both UEFI and Legacy BIOS boot
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
WORK_DIR_ABS="$(pwd)"

# Download base ISO if not provided
if [ -z "$BASE_ISO" ] || [ ! -f "$BASE_ISO" ]; then
    echo "Downloading Kubuntu 24.04..."
    BASE_ISO="$WORK_DIR_ABS/kubuntu-24.04.4-desktop-amd64.iso"
    wget --progress=bar:force -O "$BASE_ISO" "$KUBUNTU_URL" || {
        echo "Download failed. Use: $0 /path/to/kubuntu-24.04-desktop-amd64.iso"
        exit 1
    }
fi

echo "=== x-Nord OS CI Build ==="
echo "Base: $BASE_ISO"
echo "Work: $WORK_DIR_ABS"

# Create directories (use absolute paths for overlay)
mkdir -p iso squash upper work chroot newiso
sudo rm -rf iso/* upper/* work/* chroot/* newiso/* 2>/dev/null || true

# Mount ISO
echo "Mounting ISO..."
sudo mount -o loop,ro "$BASE_ISO" "$WORK_DIR_ABS/iso"

# Detect squashfs (Ubuntu 24.04 may use filesystem.squashfs or minimal.squashfs)
SQUASHFS=""
for f in filesystem.squashfs minimal.squashfs; do
    if [ -f "$WORK_DIR_ABS/iso/casper/$f" ]; then
        SQUASHFS="$WORK_DIR_ABS/iso/casper/$f"
        break
    fi
done
if [ -z "$SQUASHFS" ]; then
    echo "Error: No squashfs found in casper/"
    ls -la "$WORK_DIR_ABS/iso/casper/" 2>/dev/null || true
    exit 1
fi
echo "Using squashfs: $SQUASHFS"

# Mount squashfs
echo "Mounting squashfs..."
sudo mount -t squashfs -o ro "$SQUASHFS" "$WORK_DIR_ABS/squash"

# Overlay for writable layer (absolute paths required)
echo "Creating overlay..."
sudo mount -t overlay overlay -o "lowerdir=$WORK_DIR_ABS/squash,upperdir=$WORK_DIR_ABS/upper,workdir=$WORK_DIR_ABS/work" "$WORK_DIR_ABS/chroot"

# Mount binds for chroot
sudo mount --bind /dev "$WORK_DIR_ABS/chroot/dev"
sudo mount --bind /run "$WORK_DIR_ABS/chroot/run"
sudo mount -t proc none "$WORK_DIR_ABS/chroot/proc"
sudo mount -t sysfs none "$WORK_DIR_ABS/chroot/sys"
sudo mount -t devpts none "$WORK_DIR_ABS/chroot/dev/pts"
sudo cp /etc/resolv.conf "$WORK_DIR_ABS/chroot/etc/resolv.conf" 2>/dev/null || true

# Run x-Nord install
echo "Applying x-Nord customizations..."
sudo "$SCRIPT_DIR/install-to-chroot.sh" "$WORK_DIR_ABS/chroot"

# Unmount binds
sudo umount "$WORK_DIR_ABS/chroot/dev/pts" "$WORK_DIR_ABS/chroot/dev" "$WORK_DIR_ABS/chroot/run" "$WORK_DIR_ABS/chroot/proc" "$WORK_DIR_ABS/chroot/sys" 2>/dev/null || true

# Copy ISO contents (excluding squashfs) to newiso
echo "Preparing new ISO..."
rsync -a --exclude='casper/filesystem.squashfs' --exclude='casper/filesystem.size' --exclude='casper/minimal*.squashfs' "$WORK_DIR_ABS/iso/" "$WORK_DIR_ABS/newiso/"

# Determine output squashfs name (match original)
SQUASHFS_NAME=$(basename "$SQUASHFS")
echo "Creating new $SQUASHFS_NAME (this takes several minutes)..."
sudo mksquashfs "$WORK_DIR_ABS/chroot" "$WORK_DIR_ABS/newiso/casper/$SQUASHFS_NAME" -noappend -comp xz -Xbcj x86

# Update filesystem.size if it exists
if [ -f "$WORK_DIR_ABS/iso/casper/filesystem.size" ]; then
    printf '%s' "$(sudo du -sx --block-size=1 "$WORK_DIR_ABS/chroot" | cut -f1)" | sudo tee "$WORK_DIR_ABS/newiso/casper/filesystem.size" > /dev/null
fi

# Unmount overlay and squash
sudo umount "$WORK_DIR_ABS/chroot"
sudo umount "$WORK_DIR_ABS/squash"
sudo umount "$WORK_DIR_ABS/iso"

# === Prepare hybrid UEFI + Legacy BIOS boot ===
cd "$WORK_DIR_ABS/newiso"

# Ensure isolinux structure exists (Kubuntu may use boot/isolinux or isolinux at root)
if [ -d "boot/isolinux" ] && [ ! -d "isolinux" ]; then
    echo "Copying isolinux from boot/isolinux..."
    mkdir -p isolinux
    cp -a boot/isolinux/* isolinux/
fi
if [ ! -d "isolinux" ]; then
    echo "Error: No isolinux directory found in ISO"
    find . -name "isolinux.bin" 2>/dev/null || true
    exit 1
fi

# Install x-Nord isolinux config
if [ -f "$PROJECT_ROOT/config/isolinux/isolinux.cfg" ]; then
    cp "$PROJECT_ROOT/config/isolinux/isolinux.cfg" isolinux/isolinux.cfg
fi

# Detect initrd filename (Ubuntu may use initrd, initrd.lz, etc.)
INITRD="initrd"
for f in initrd initrd.lz initrd.lz4; do
    if [ -f "casper/$f" ]; then
        INITRD="$f"
        break
    fi
done
echo "Using initrd: casper/$INITRD"

# Create EFI/BOOT structure for UEFI boot (required for UTM on Apple Silicon)
echo "Creating EFI boot structure..."
mkdir -p EFI/BOOT

# Generate GRUB EFI bootloader
GRUB_MODS="part_gpt part_msdos fat iso9660 normal boot linux initrd configfile loopback chain efifwsetup efi_gop efi_uga ls search search_label search_fs_uuid search_fs_file gfxterm gfxterm_background test true loadenv"
if command -v grub-mkimage >/dev/null 2>&1; then
    grub-mkimage -o EFI/BOOT/BOOTX64.EFI -O x86_64-efi -p /EFI/BOOT \
        $GRUB_MODS
else
    echo "Warning: grub-mkimage not found, extracting from existing ISO..."
    # Fallback: extract from boot/grub/efi.img if it exists
    if [ -f "boot/grub/efi.img" ]; then
        mkdir -p /tmp/efi-mnt
        sudo mount -o loop,ro boot/grub/efi.img /tmp/efi-mnt 2>/dev/null && {
            cp -a /tmp/efi-mnt/EFI/BOOT/BOOTX64.EFI EFI/BOOT/ 2>/dev/null || \
            cp -a /tmp/efi-mnt/efi/boot/bootx64.efi EFI/BOOT/BOOTX64.EFI 2>/dev/null || true
            sudo umount /tmp/efi-mnt
        }
    fi
fi

# Create grub.cfg for UEFI (use detected initrd)
cat > EFI/BOOT/grub.cfg << EOF
set default=0
set timeout=5

menuentry "xNord OS" {
  set gfxpayload=keep
  linux /casper/vmlinuz boot=casper quiet splash ---
  initrd /casper/$INITRD
}

menuentry "xNord OS (safe mode)" {
  linux /casper/vmlinuz boot=casper xforcevesa ---
  initrd /casper/$INITRD
}
EOF

# Update isolinux.cfg with correct initrd path
if [ -f "isolinux/isolinux.cfg" ]; then
    sed -i "s|initrd=/casper/[^ ]*|initrd=/casper/$INITRD|g" isolinux/isolinux.cfg
fi

# Ensure boot.cat exists for isolinux
if [ ! -f "isolinux/boot.cat" ] && [ -f "isolinux/isolinux.bin" ]; then
    echo "Generating isolinux boot.cat..."
    genisoimage -o /dev/null -b isolinux/isolinux.bin -c isolinux/boot.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table -V xNordOS . 2>/dev/null || true
fi

# Determine EFI boot image path (prefer our EFI/BOOT, fallback to existing)
EFI_BOOT_IMG=""
[ -f "EFI/BOOT/BOOTX64.EFI" ] && EFI_BOOT_IMG="EFI/BOOT/BOOTX64.EFI"
[ -z "$EFI_BOOT_IMG" ] && [ -f "EFI/boot/bootx64.efi" ] && EFI_BOOT_IMG="EFI/boot/bootx64.efi"
[ -z "$EFI_BOOT_IMG" ] && [ -f "boot/grub/efi.img" ] && EFI_BOOT_IMG="boot/grub/efi.img"
if [ -z "$EFI_BOOT_IMG" ]; then
    echo "Error: No EFI boot image found. Install grub-efi-amd64-bin for UEFI support."
    exit 1
fi

# Build hybrid ISO with xorriso
echo "Building final hybrid ISO..."
OUTPUT_ISO="$PROJECT_ROOT/xnord-os-1.0-amd64.iso"

xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "xNordOS" \
    -eltorito-boot isolinux/isolinux.bin \
    -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot \
    -e "${EFI_BOOT_IMG:-EFI/BOOT/BOOTX64.EFI}" \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -o "$OUTPUT_ISO" \
    . || {
    echo "Primary xorriso failed, trying fallback..."
    xorriso -as mkisofs -r -V "xNordOS" -o "$OUTPUT_ISO" -J -l -cache-inodes \
        -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table \
        -eltorito-alt-boot -e "${EFI_BOOT_IMG:-EFI/BOOT/BOOTX64.EFI}" -no-emul-boot \
        -isohybrid-gpt-basdat .
}

echo "Build complete: $OUTPUT_ISO"
