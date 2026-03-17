#!/bin/bash
# Configure Flatpak and Discover for x-Nord OS curated store
# Run in chroot or on installed system

set -e

# Add Flathub if not present
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Configure Discover to prefer Flatpak
# Discover reads from /usr/share/plasma/discover/flatpak-backend/
# Default config is usually sufficient

# Optional: Install curated apps (commented - user choice)
# CURATED_DIR="$(dirname "$0")/../packages/xnord-flatpak-curated"
# while IFS= read -r app; do
#   [[ "$app" =~ ^#.*$ || -z "$app" ]] && continue
#   flatpak install -y flathub "$app" 2>/dev/null || true
# done < <(grep -E '^\s+-\s+' "$CURATED_DIR/curated-apps.yaml" | sed 's/.*-\s*//')

echo "Flatpak configured. Open Discover to browse curated apps."
