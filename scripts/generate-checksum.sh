#!/bin/bash
# Generate SHA256 checksum for x-Nord OS ISO
# Usage: ./generate-checksum.sh [path-to-iso]

ISO="${1:-xnord-os-1.0-amd64.iso}"

if [ ! -f "$ISO" ]; then
    echo "Error: ISO not found: $ISO"
    echo "Usage: $0 [path-to-iso]"
    echo "Example: $0 xnord-os-1.0-amd64.iso"
    exit 1
fi

echo "Generating SHA256 checksum for $ISO..."
sha256sum "$ISO" > "${ISO}.sha256" 2>/dev/null || shasum -a 256 "$ISO" > "${ISO}.sha256"
echo "Created: ${ISO}.sha256"
cat "${ISO}.sha256"
