# Testing x-Nord OS on macOS

Step-by-step instructions for testing the x-Nord OS ISO locally on Mac using **QEMU** or **UTM**. Works on both **Intel** and **Apple Silicon** Macs.

**Contact:** hello@xnord.co.uk

---

## Prerequisites

- x-Nord OS ISO (`xnord-os-1.0-amd64.iso`) in the project directory or built via Cubic
- macOS 11 (Big Sur) or later

---

## Option 1: QEMU (Command Line)

### 1. Install QEMU

```bash
./scripts/install-qemu-mac.sh
```

This installs Homebrew (if needed) and QEMU. Takes 2–5 minutes.

### 2. Launch the ISO

```bash
./scripts/test-iso-mac.sh
```

The script will:
- Find the ISO automatically (`xnord-os-1.0-amd64.iso` or `custom-live-amd64.iso`)
- Launch QEMU with 4GB RAM, 2 CPU cores
- Use HVF acceleration on Intel Macs, TCG on Apple Silicon
- Open a display window

### 3. Boot

- Select "Try or Install x-Nord OS" from the boot menu
- The live desktop will load
- Close the QEMU window or press Ctrl+C in the terminal to exit

### Performance Notes

| Mac Type      | Acceleration | Performance        |
|---------------|--------------|--------------------|
| Intel         | HVF          | Near native        |
| Apple Silicon | TCG          | Slower (emulation) |

On Apple Silicon, boot may take 2–5 minutes due to x86_64 emulation.

---

## Option 2: UTM (GUI)

### 1. Install UTM

**Download:** https://mac.getutm.app

Or from GitHub: https://github.com/utmapp/UTM/releases/latest

**Installation:**
1. Download `UTM.dmg` from the latest release
2. Open the DMG
3. Drag **UTM.app** to **Applications**
4. Open UTM (you may need to allow it in System Preferences → Security)

### 2. Create the VM

1. Open **UTM**
2. Click **Create a New Virtual Machine**
3. Choose **Emulate** (x-Nord is x86_64; on Apple Silicon this uses QEMU emulation)
4. Select **Linux** → **Other Linux (x86_64)**
5. **RAM:** 4096 MB  
   **CPU Cores:** 2
6. **Boot ISO Image:** Click **Browse** and select `xnord-os-1.0-amd64.iso`
7. **Network:** Shared Network (default)
8. Name the VM: **x-Nord OS**
9. Click **Save**

### 3. Start the VM

1. Select **x-Nord OS** in the UTM library
2. Click **Run** (play button)
3. In the boot menu, select **Try or Install x-Nord OS**
4. The live desktop will load

### Reference Config

See `scripts/xnord-utm.json` for the exact VM settings.

---

## Troubleshooting

### "No ISO found"
Place `xnord-os-1.0-amd64.iso` in the project root or run:
```bash
./scripts/test-iso-mac.sh /path/to/your/xnord-os-1.0-amd64.iso
```

### "QEMU not found"
Run `./scripts/install-qemu-mac.sh` and ensure Homebrew is in your PATH. On Apple Silicon, you may need:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Slow boot on Apple Silicon
Expected. x86_64 on arm64 uses software emulation (TCG). Boot can take 3–5 minutes. UTM and QEMU behave similarly.

### Display issues
If the window is black, wait 1–2 minutes for the boot process. Plymouth and the desktop take time to load.

### Mouse/keyboard capture
In QEMU/UTM, click inside the VM window to capture input. Press **Ctrl+Option** (or **Ctrl+Alt** on some setups) to release.

---

## Quick Reference

| Task              | Command / Action                          |
|-------------------|-------------------------------------------|
| Install QEMU      | `./scripts/install-qemu-mac.sh`          |
| Test with QEMU    | `./scripts/test-iso-mac.sh`              |
| Test with UTM     | Install UTM → Create VM → Boot from ISO  |
| Custom ISO path   | `./scripts/test-iso-mac.sh /path/to.iso` |
