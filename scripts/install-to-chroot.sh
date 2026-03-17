#!/bin/bash
# Install x-Nord OS customizations into a Cubic chroot
# Usage: ./install-to-chroot.sh /path/to/chroot

set -e

CHROOT="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

if [ -z "$CHROOT" ] || [ ! -d "$CHROOT" ]; then
    echo "Usage: $0 /path/to/chroot"
    echo "Example: $0 /tmp/cubic/chroot"
    exit 1
fi

echo "Installing x-Nord OS into $CHROOT"

# Copy Plymouth theme (includes logo-os.png)
mkdir -p "$CHROOT/usr/share/plymouth/themes"
cp -r "$PROJECT_ROOT/packages/plymouth-theme-xnord" "$CHROOT/usr/share/plymouth/themes/xnord"

# Copy SDDM theme
mkdir -p "$CHROOT/usr/share/sddm/themes"
cp -r "$PROJECT_ROOT/packages/sddm-theme-xnord" "$CHROOT/usr/share/sddm/themes/xnord"

# Copy Calamares config
mkdir -p "$CHROOT/etc/calamares"
cp "$PROJECT_ROOT/packages/xnord-calamares-config/settings.conf" "$CHROOT/etc/calamares/"
mkdir -p "$CHROOT/etc/calamares/modules"
# Copy only our custom module configs (others use Calamares defaults)
for f in "$PROJECT_ROOT/packages/xnord-calamares-config/modules/"*.conf; do
    [ -f "$f" ] && cp "$f" "$CHROOT/etc/calamares/modules/"
done
mkdir -p "$CHROOT/etc/calamares/branding"
cp -r "$PROJECT_ROOT/packages/xnord-calamares-config/branding/"* "$CHROOT/etc/calamares/branding/"

# Copy Plasma color scheme
mkdir -p "$CHROOT/usr/share/color-schemes"
cp "$PROJECT_ROOT/packages/xnord-plasma-theme/xnord.colors" "$CHROOT/usr/share/color-schemes/"

# Copy AI panel plasmoid
mkdir -p "$CHROOT/usr/share/plasma/plasmoids"
cp -r "$PROJECT_ROOT/packages/xnord-ai-panel" "$CHROOT/usr/share/plasma/plasmoids/org.xnord.ai"

# Copy skel config (default user settings)
if [ -d "$PROJECT_ROOT/config/skel" ]; then
    mkdir -p "$CHROOT/etc/skel"
    cp -a "$PROJECT_ROOT/config/skel"/. "$CHROOT/etc/skel/"
fi

# Copy Ollama systemd service
mkdir -p "$CHROOT/etc/systemd/system"
cp "$PROJECT_ROOT/packages/ollama/ollama.service" "$CHROOT/etc/systemd/system/"

# Copy SDDM config
mkdir -p "$CHROOT/etc/sddm.conf.d"
cp "$PROJECT_ROOT/config/sddm.conf.d/xnord.conf" "$CHROOT/etc/sddm.conf.d/"

# Run post-install script inside chroot
cp "$SCRIPT_DIR/chroot-post-install.sh" "$CHROOT/tmp/xnord-post-install.sh"
chmod +x "$CHROOT/tmp/xnord-post-install.sh"
chroot "$CHROOT" /tmp/xnord-post-install.sh
rm -f "$CHROOT/tmp/xnord-post-install.sh"

echo "x-Nord OS installation complete."
