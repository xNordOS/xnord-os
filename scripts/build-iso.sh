#!/bin/bash
# x-Nord OS ISO Build Script
# Usage: ./build-iso.sh [kubuntu-24.04-desktop-amd64.iso]
# In CI: uses ci-build-iso.sh automatically (headless)
# Locally with Cubic: run manually or use ci-build-iso.sh for headless
# Contact: hello@xnord.co.uk

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BASE_ISO="${1:-}"

# In CI or when CI_BUILD=1, use headless build
if [ -n "$CI" ] || [ -n "$CI_BUILD" ] || [ -n "$GITHUB_ACTIONS" ]; then
    exec "$SCRIPT_DIR/ci-build-iso.sh" "$BASE_ISO"
fi

# Local: show Cubic instructions (interactive)
if [ -z "$BASE_ISO" ]; then
    echo "Usage: $0 /path/to/kubuntu-24.04-desktop-amd64.iso"
    echo ""
    echo "For headless/CI build: CI_BUILD=1 $0"
    echo "Or run: ./scripts/ci-build-iso.sh"
    echo ""
    echo "Download Kubuntu 24.04 from: https://kubuntu.org/getkubuntu/"
    exit 1
fi

if [ ! -f "$BASE_ISO" ]; then
    echo "Error: ISO not found: $BASE_ISO"
    exit 1
fi

echo "=== x-Nord OS Build (Cubic) ==="
echo "Base ISO: $BASE_ISO"
echo ""
echo "Manual steps:"
echo "1. Launch Cubic: cubic"
echo "2. Select: $BASE_ISO"
echo "3. After extraction, run: sudo $SCRIPT_DIR/install-to-chroot.sh /path/to/chroot"
echo "4. In Cubic, click 'Generate'"
echo ""
echo "For automated headless build: ./scripts/ci-build-iso.sh $BASE_ISO"
