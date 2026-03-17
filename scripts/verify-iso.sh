#!/bin/bash
# x-Nord OS ISO Verification Script
# Verifies the ISO is valid, bootable, and contains all x-Nord customizations
# Usage: ./verify-iso.sh xnord-os-1.0-amd64.iso
# Note: Content verification (mount) requires Linux. Basic checks work on macOS.

set -e

ISO="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MOUNT_POINT="/tmp/xnord-iso-verify-$$"
EXIT_CODE=0

cleanup() {
    if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
        sudo umount "$MOUNT_POINT" 2>/dev/null || true
    fi
    rmdir "$MOUNT_POINT" 2>/dev/null || true
}
trap cleanup EXIT

usage() {
    echo "Usage: $0 <path-to-iso>"
    echo "Example: $0 xnord-os-1.0-amd64.iso"
    exit 1
}

check_pass() { echo "  [PASS] $1"; }
check_fail() { echo "  [FAIL] $1"; EXIT_CODE=1; }
check_warn() { echo "  [WARN] $1"; }

if [ -z "$ISO" ] || [ ! -f "$ISO" ]; then
    echo "Error: ISO file not found: $ISO"
    usage
fi

echo "=========================================="
echo "x-Nord OS ISO Verification"
echo "=========================================="
echo "ISO: $ISO"
echo "Size: $(du -h "$ISO" | cut -f1)"
echo ""

# 1. Basic ISO validity
echo "1. Basic ISO validity"
if file "$ISO" | grep -q "ISO 9660\|DOS/MBR boot sector"; then
    check_pass "Valid ISO 9660 / hybrid structure"
else
    check_fail "Invalid ISO format: $(file "$ISO")"
fi

if [ -s "$ISO" ]; then
    SIZE=$(stat -c%s "$ISO" 2>/dev/null || stat -f%z "$ISO" 2>/dev/null)
    check_pass "Non-empty file (${SIZE} bytes)"
else
    check_fail "Empty file"
fi
echo ""

# 2. Bootability
echo "2. Bootability"
if grep -q "isolinux\|syslinux\|boot.cat\|efi" <(strings "$ISO" | head -10000); then
    check_pass "Contains boot loader signatures"
else
    check_warn "Boot signatures not found (may still be bootable)"
fi

if strings "$ISO" | grep -q "menu.c32\|vesamenu\|isolinux"; then
    check_pass "ISOLINUX/Syslinux present"
fi
echo ""

# 3. Mount and verify contents
echo "3. Contents verification (mounting ISO)"
mkdir -p "$MOUNT_POINT"
if sudo mount -o loop,ro "$ISO" "$MOUNT_POINT" 2>/dev/null; then
    check_pass "ISO mounted successfully"
    
    # x-Nord Plymouth theme
    if [ -d "$MOUNT_POINT/usr/share/plymouth/themes/xnord" ]; then
        check_pass "Plymouth x-Nord theme present"
        [ -f "$MOUNT_POINT/usr/share/plymouth/themes/xnord/xnord.plymouth" ] && check_pass "  xnord.plymouth"
        [ -f "$MOUNT_POINT/usr/share/plymouth/themes/xnord/xnord.script" ] && check_pass "  xnord.script"
        [ -f "$MOUNT_POINT/usr/share/plymouth/themes/xnord/logo-os.png" ] && check_pass "  logo-os.png"
    else
        check_fail "Plymouth x-Nord theme missing"
    fi
    
    # SDDM theme
    if [ -d "$MOUNT_POINT/usr/share/sddm/themes/xnord" ]; then
        check_pass "SDDM x-Nord theme present"
        [ -f "$MOUNT_POINT/usr/share/sddm/themes/xnord/theme.conf" ] && check_pass "  theme.conf"
        [ -f "$MOUNT_POINT/usr/share/sddm/themes/xnord/Main.qml" ] && check_pass "  Main.qml"
    else
        check_fail "SDDM x-Nord theme missing"
    fi
    
    # Calamares branding
    if [ -d "$MOUNT_POINT/etc/calamares/branding/xnord" ]; then
        check_pass "Calamares x-Nord branding present"
        [ -f "$MOUNT_POINT/etc/calamares/branding/xnord/branding.desc" ] && check_pass "  branding.desc"
    else
        check_fail "Calamares x-Nord branding missing"
    fi
    
    # Plasma color scheme
    if [ -f "$MOUNT_POINT/usr/share/color-schemes/xnord.colors" ]; then
        check_pass "x-Nord Plasma color scheme present"
    else
        check_fail "x-Nord color scheme missing"
    fi
    
    # AI plasmoid
    if [ -d "$MOUNT_POINT/usr/share/plasma/plasmoids/org.xnord.ai" ]; then
        check_pass "x-Nord AI plasmoid present"
    else
        check_fail "x-Nord AI plasmoid missing"
    fi
    
    # SDDM config
    if grep -q "xnord" "$MOUNT_POINT/etc/sddm.conf.d/xnord.conf" 2>/dev/null; then
        check_pass "SDDM configured for x-Nord theme"
    else
        check_warn "SDDM xnord.conf may be missing"
    fi
    
    # Base system
    [ -d "$MOUNT_POINT/casper" ] && check_pass "Ubuntu live structure (casper)"
    [ -f "$MOUNT_POINT/README.diskdefines" ] && check_pass "Ubuntu disk defines"
    
    sudo umount "$MOUNT_POINT"
else
    check_warn "Could not mount ISO (try as root). Skipping content checks."
fi
echo ""

# 4. Checksum
echo "4. Checksum"
if [ -f "${ISO}.sha256" ]; then
    if sha256sum -c "${ISO}.sha256" 2>/dev/null || shasum -a 256 -c "${ISO}.sha256" 2>/dev/null; then
        check_pass "SHA256 checksum verified"
    else
        check_fail "SHA256 checksum mismatch"
    fi
else
    echo "  SHA256: $(sha256sum "$ISO" 2>/dev/null | cut -d' ' -f1 || shasum -a 256 "$ISO" 2>/dev/null | cut -d' ' -f1)"
    check_warn "No .sha256 file found. Create with: sha256sum $ISO > ${ISO}.sha256"
fi
echo ""

# Summary
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "Verification PASSED"
else
    echo "Verification FAILED (see above)"
fi
echo "=========================================="
exit $EXIT_CODE
