#!/bin/bash
# Install Plymouth theme (run as root or via package)
THEME_DIR="/usr/share/plymouth/themes/xnord"
mkdir -p "$THEME_DIR"
cp -r "$(dirname "$0")"/* "$THEME_DIR/" 2>/dev/null || cp "$(dirname "$0")"/*.plymouth "$(dirname "$0")"/*.script "$THEME_DIR/"
update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth "$THEME_DIR/xnord.plymouth" 100
update-alternatives --set default.plymouth "$THEME_DIR/xnord.plymouth"
update-initramfs -u -k all
