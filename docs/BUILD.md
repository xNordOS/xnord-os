# x-Nord OS Build Guide

## Prerequisites

- Ubuntu 24.04 LTS host system
- 50 GB free disk space
- Cubic (Custom Ubuntu ISO Creator)

## Install Cubic

```bash
sudo apt-add-repository ppa:cubic-wizard/release
sudo apt update
sudo apt install cubic
```

## Build Steps

1. **Download base ISO**
   - Get Kubuntu 24.04 Desktop ISO (amd64) from https://kubuntu.org/getkubuntu/
   - Use Desktop edition (not Server) to avoid Cubic extraction issues

2. **Launch Cubic**
   - Run `cubic`
   - Select the Kubuntu 24.04 ISO
   - Choose a project directory (e.g. `~/xnord-build`)
   - Wait for extraction to complete

3. **Apply customizations**
   - When Cubic opens the chroot terminal, the project directory is typically under `/home/$USER/cubic/` or similar
   - From your host (another terminal), run:
   ```bash
   cd /path/to/xnord-os
   sudo ./scripts/install-to-chroot.sh /path/to/cubic/chroot
   ```
   - The chroot path is shown in Cubic's window (e.g. `/home/user/cubic/custom-live-iso/chroot`)

4. **Install Ollama (optional, in chroot)**
   ```bash
   chroot /path/to/cubic/chroot
   curl -fsSL https://ollama.com/install.sh | sh
   exit
   ```

5. **Build ISO**
   - In Cubic, click "Generate" to create the final ISO
   - Output: `custom-live-amd64.iso` (rename to `xnord-os-1.0-amd64.iso`)

## Verification

```bash
./scripts/generate-checksum.sh xnord-os-1.0-amd64.iso
```

Or manually: `sha256sum xnord-os-1.0-amd64.iso > xnord-os-1.0-amd64.iso.sha256`

## Project Structure

```
xnord-os/
├── assets/           # Logo and branding
├── config/           # Default user config (skel)
├── docs/             # Documentation
├── packages/         # Theme and config packages
│   ├── plymouth-theme-xnord/
│   ├── sddm-theme-xnord/
│   ├── xnord-calamares-config/
│   ├── xnord-plasma-theme/
│   ├── xnord-ai-panel/
│   ├── xnord-flatpak-curated/
│   └── ollama/
└── scripts/          # Build and install scripts
```
