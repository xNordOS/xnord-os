# x-Nord OS

<p align="center">
  <img src="assets/logo-os.png" alt="x-Nord OS Logo" width="120"/>
</p>

[![Build ISO](https://github.com/JosephSRobinson/xnord-os/actions/workflows/build-iso.yml/badge.svg)](https://github.com/JosephSRobinson/xnord-os/actions/workflows/build-iso.yml)

**A Nordic-inspired Linux distribution.** Minimal, clean, fast, private, and beautiful.

Built on Ubuntu 24.04 LTS with KDE Plasma 5. Black, white, slate blue. The X mark.

---

## Features

| Feature | Description |
|---------|-------------|
| **Windows-style UX** | Taskbar, start menu, system tray — familiar and polished |
| **Local AI Assistant** | Ollama + Llama 3 runs entirely on-device. No cloud. Full privacy. |
| **Custom Theme** | Plymouth boot splash, SDDM login, KDE Plasma colour scheme |
| **5-Step Installer** | Calamares — simple for non-technical users |
| **Curated App Store** | Flatpak via Discover — sandboxed, curated apps |

---

## Download

- **[Download ISO](https://download.xnord.co.uk/xnord-os-1.0-amd64.iso)** — Primary download
- **[GitHub Releases](https://github.com/xnord-os/xnord-os/releases)** — Checksums and release notes

### Verify Your Download

```bash
sha256sum -c xnord-os-1.0-amd64.iso.sha256
```

---

## Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 8 GB | 16 GB+ (for AI) |
| Storage | 30 GB | 50 GB SSD |
| Architecture | x86_64 | — |

---

## Quick Start

### Build from Source

```bash
# Prerequisites: Ubuntu 24.04, Cubic
./scripts/build-iso.sh /path/to/kubuntu-24.04-desktop-amd64.iso
```

### Verify ISO

```bash
./scripts/verify-iso.sh xnord-os-1.0-amd64.iso
```

### Test on macOS (QEMU / UTM)

```bash
./scripts/install-qemu-mac.sh   # Install QEMU (one-time)
./scripts/test-iso-mac.sh      # Launch ISO
```

See [scripts/README-TESTING.md](scripts/README-TESTING.md) for UTM and troubleshooting.

---

## Documentation

| Document | Description |
|----------|-------------|
| [Build Guide](docs/BUILD.md) | Full build instructions with Cubic |
| [Install Guide](docs/INSTALL.md) | Installation and first boot |
| [Hardware](docs/HARDWARE.md) | Supported hardware |
| [Hosting](docs/HOSTING.md) | Upload ISO to R2, SourceForge |
| [DistroSea](docs/DISTROSEA.md) | Submission materials for distrosea.com |
| [Launch: Reddit](docs/LAUNCH-REDDIT-LINUX.md) | r/linux and r/unixporn posts |
| [Launch: Twitter/X](docs/LAUNCH-TWITTER.md) | Announcement tweets |
| [CI Build](docs/CI-BUILD.md) | GitHub Actions automated ISO build |

---

## Project Structure

```
xnord-os/
├── assets/              # Logo and branding
│   ├── logo-os.png
│   └── logo-xnord.svg
├── config/              # Default user config
│   ├── skel/            # /etc/skel templates
│   └── sddm.conf.d/
├── docs/                # Documentation
├── packages/            # Themes and configs
│   ├── plymouth-theme-xnord/
│   ├── sddm-theme-xnord/
│   ├── xnord-calamares-config/
│   ├── xnord-plasma-theme/
│   ├── xnord-ai-panel/
│   ├── xnord-flatpak-curated/
│   └── ollama/
├── scripts/
│   ├── build-iso.sh
│   ├── verify-iso.sh
│   ├── generate-checksum.sh
│   ├── test-iso-mac.sh
│   ├── install-qemu-mac.sh
│   ├── install-to-chroot.sh
│   ├── xnord-utm.json
│   ├── README-TESTING.md
│   └── ...
├── LICENSE
└── README.md
```

---

## Tech Stack

- **Base:** Ubuntu 24.04 LTS (Noble Numbat)
- **Desktop:** KDE Plasma 5.27
- **Installer:** Calamares
- **AI:** Ollama + Llama 3.2 3B
- **Apps:** Flatpak (Flathub)

---

## Contributing

Contributions welcome. Please open an issue or PR.

---

## License

x-Nord OS branding and themes: **MIT**  
Upstream components: their respective licenses.

---

## Links

- **GitHub:** [github.com/xnord-os/xnord-os](https://github.com/xnord-os/xnord-os)
- **Contact:** hello@xnord.co.uk
