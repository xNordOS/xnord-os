#!/bin/bash
# Install QEMU on macOS via Homebrew (for testing x-Nord OS ISO)
# Supports both Intel and Apple Silicon Macs
# Contact: hello@xnord.co.uk

set -e

echo "=== x-Nord OS — QEMU Installer for macOS ==="

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to PATH for Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install QEMU
echo "Installing QEMU..."
brew install qemu

# Verify
if command -v qemu-system-x86_64 &>/dev/null; then
    echo ""
    echo "QEMU installed successfully."
    qemu-system-x86_64 --version | head -1
else
    echo "Error: QEMU installation may have failed."
    exit 1
fi
