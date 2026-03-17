#!/bin/bash
# Launch x-Nord OS ISO in QEMU on macOS
# Supports both Intel and Apple Silicon Macs
# Contact: hello@xnord.co.uk

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Find ISO (check project root and one level down)
ISO=""
if [ -f "$PROJECT_ROOT/xnord-os-1.0-amd64.iso" ]; then
    ISO="$PROJECT_ROOT/xnord-os-1.0-amd64.iso"
elif [ -f "$PROJECT_ROOT/custom-live-amd64.iso" ]; then
    ISO="$PROJECT_ROOT/custom-live-amd64.iso"
elif [ -n "$1" ] && [ -f "$1" ]; then
    ISO="$1"
else
    found=$(find "$PROJECT_ROOT" -maxdepth 2 -name "*.iso" -type f 2>/dev/null | head -1)
    ISO="$found"
fi

if [ -z "$ISO" ] || [ ! -f "$ISO" ]; then
    echo "Error: No x-Nord ISO found."
    echo "Place xnord-os-1.0-amd64.iso in: $PROJECT_ROOT"
    echo "Or specify path: $0 /path/to/xnord-os-1.0-amd64.iso"
    exit 1
fi

# Check QEMU
if ! command -v qemu-system-x86_64 &>/dev/null; then
    echo "QEMU not found. Run: ./scripts/install-qemu-mac.sh"
    exit 1
fi

# Architecture: Intel can use HVF; Apple Silicon uses TCG for x86_64 guests
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ACCEL="-accel hvf"
else
    # Apple Silicon: TCG for x86_64 emulation (HVF only accelerates arm64 guests)
    ACCEL="-accel tcg"
fi

echo "=========================================="
echo "x-Nord OS — QEMU Test"
echo "=========================================="
echo "ISO: $ISO"
echo "RAM: 4GB | CPUs: 2"
echo "Arch: $ARCH"
echo ""
echo "Booting... (Close window or Ctrl+C to exit)"
echo "=========================================="

qemu-system-x86_64 \
    $ACCEL \
    -m 4096 \
    -smp 2 \
    -cdrom "$ISO" \
    -boot d \
    -display cocoa \
    -device qemu-xhci,id=usb \
    -device usb-tablet \
    -device usb-mouse \
    -nic user,model=virtio-net-pci

echo ""
echo "x-Nord OS VM closed. Boot test complete."
