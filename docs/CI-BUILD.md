# x-Nord OS CI Build

The ISO is built automatically by GitHub Actions on every push to `main`.

## Workflow

1. **Trigger:** Push to `main` or manual `workflow_dispatch`
2. **Runner:** Ubuntu 24.04
3. **Steps:** Install deps → Build ISO → Generate checksum → Verify → Upload artifact

## Download the ISO

1. Go to **Actions** → **Build x-Nord OS ISO**
2. Click the latest successful run
3. Scroll to **Artifacts** → download **xnord-os-iso** (contains `.iso` and `.sha256`)

## Local CI Build

To run the same build locally (Ubuntu 24.04):

```bash
./scripts/install-deps.sh
CI_BUILD=1 ./scripts/ci-build-iso.sh
```

Or with a pre-downloaded base ISO:

```bash
./scripts/ci-build-iso.sh /path/to/kubuntu-24.04-desktop-amd64.iso
```

## Build Badge

Update the badge in README.md if your repo is not `xnord-os/xnord-os`:

```markdown
[![Build ISO](https://github.com/YOUR_ORG/YOUR_REPO/actions/workflows/build-iso.yml/badge.svg)](https://github.com/YOUR_ORG/YOUR_REPO/actions/workflows/build-iso.yml)
```

**Contact:** hello@xnord.co.uk
