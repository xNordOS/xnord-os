# DistroSea Submission — x-Nord OS

Use the content below to submit x-Nord OS to [DistroSea](https://distrosea.com).

---

## Submission Form Fields

### Distribution Name
```
x-Nord OS
```

### Short Description (tagline, ~80 chars)
```
Nordic-inspired Linux. Ubuntu 24.04 + KDE Plasma. Local AI, privacy-first, Windows-style UX.
```

### Full Description
```
x-Nord OS is a minimal, privacy-focused Linux distribution built on Ubuntu 24.04 LTS with KDE Plasma 5. The design philosophy is Nordic-inspired: clean, fast, and beautiful, with brand colours of black, white, and slate blue.

Key features:
• Windows-style taskbar, start menu, and system tray for familiar UX
• Built-in local AI assistant (Ollama + Llama 3) — runs entirely on-device, no cloud, full privacy
• Custom x-Nord theme: Plymouth boot splash, SDDM login, KDE Plasma colour scheme
• 5-step Calamares installer for non-technical users
• Curated Flatpak app store (Discover)

Hardware: 8GB RAM minimum, 16GB+ recommended for AI. 30GB disk. x86_64 only.

Perfect for users who want a polished, Windows-like Linux experience with on-device AI and zero telemetry.
```

### Base Distribution
```
Ubuntu 24.04 LTS
```

### Desktop Environment
```
KDE Plasma 5
```

### Architecture
```
x86_64 (amd64)
```

### Category
```
Desktop
```

### License
```
MIT (branding/themes), various (upstream components)
```

### Website
```
https://github.com/xnord-os/xnord-os
```

### Download URL
```
https://download.xnord.co.uk/xnord-os-1.0-amd64.iso
```
*(Primary download — update if using different host)*

### Contact Email
```
hello@xnord.co.uk
```

### Screenshots
Provide 3–5 screenshots:
1. Desktop with taskbar and start menu
2. x-Nord AI assistant panel
3. SDDM login screen
4. Calamares installer
5. Boot screen (Plymouth)

### Version
```
1.0
```

### Release Date
```
YYYY-MM-DD
```
*(Fill in actual release date)*

---

## Metadata (for distro database / JSON)

```json
{
  "name": "x-Nord OS",
  "slug": "xnord-os",
  "base": "Ubuntu",
  "base_version": "24.04",
  "desktop": "KDE Plasma",
  "desktop_version": "5",
  "arch": ["x86_64"],
  "category": "desktop",
  "init": "systemd",
  "package_manager": "apt",
  "features": [
    "local-ai",
    "flatpak",
    "calamares",
    "privacy-focused"
  ],
  "website": "https://github.com/xnord-os/xnord-os",
  "download_url": "https://download.xnord.co.uk/xnord-os-1.0-amd64.iso",
  "contact_email": "hello@xnord.co.uk",
  "license": "MIT",
  "description_short": "Nordic-inspired Linux. Ubuntu 24.04 + KDE Plasma. Local AI, privacy-first.",
  "description_long": "x-Nord OS is a minimal, privacy-focused Linux distribution built on Ubuntu 24.04 LTS with KDE Plasma 5. Features Windows-style taskbar, on-device AI (Ollama + Llama 3), custom Nordic theme, 5-step Calamares installer, and curated Flatpak store."
}
```

---

## Submission Checklist

- [ ] Create account on distrosea.com (if required)
- [ ] Have ISO hosted and download URL ready
- [ ] Prepare 3–5 screenshots (1920x1080 or similar)
- [x] Contact email: hello@xnord.co.uk
- [x] Download URL: https://download.xnord.co.uk/xnord-os-1.0-amd64.iso
- [ ] Submit via DistroSea contact form or submission page
- [ ] Follow up if no response within 1–2 weeks
