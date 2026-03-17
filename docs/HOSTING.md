# Hosting x-Nord OS ISO for Public Download

Choose one of the options below to host your ISO for public distribution.

---

## Option A: Cloudflare R2

R2 offers zero egress fees and S3-compatible API. Good for high traffic.

### Prerequisites

- Cloudflare account
- Wrangler CLI: `npm install -g wrangler`

### Step 1: Create R2 Bucket

1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Go to **R2 Object Storage** → **Create bucket**
3. Name it `xnord-os-releases` (or similar)
4. Create the bucket

### Step 2: Generate API Tokens

1. Go to **R2** → **Manage R2 API Tokens**
2. **Create API token**
3. Permissions: **Object Read & Write**
4. Copy the **Access Key ID** and **Secret Access Key**

### Step 3: Configure Wrangler

```bash
# Login
wrangler login

# Create wrangler.toml in project root
cat > wrangler.toml << 'EOF'
name = "xnord-os"
compatibility_date = "2024-01-01"

[[r2_buckets]]
binding = "RELEASES"
bucket_name = "xnord-os-releases"
EOF
```

### Step 4: Upload ISO

```bash
# Using AWS CLI (R2 is S3-compatible)
# Install: pip install awscli

# Configure (use your R2 credentials)
aws configure
# Or set env vars:
export AWS_ACCESS_KEY_ID="your-r2-access-key"
export AWS_SECRET_ACCESS_KEY="your-r2-secret-key"
export AWS_ENDPOINT_URL="https://<ACCOUNT_ID>.r2.cloudflarestorage.com"

# Upload
aws s3 cp xnord-os-1.0-amd64.iso s3://xnord-os-releases/ --endpoint-url $AWS_ENDPOINT_URL
aws s3 cp xnord-os-1.0-amd64.iso.sha256 s3://xnord-os-releases/ --endpoint-url $AWS_ENDPOINT_URL
```

### Step 5: Enable Public Access

1. In R2 bucket → **Settings** → **Public access**
2. Enable **Allow public access**
3. Or use a **Custom Domain** (e.g. `download.xnord.co.uk`) for branded URLs

### Download URL Format

- Direct: `https://pub-xxxxx.r2.dev/xnord-os-1.0-amd64.iso`
- Or custom domain: `https://download.xnord.co.uk/xnord-os-1.0-amd64.iso`

---

## Option B: SourceForge

SourceForge is free for open-source projects and provides mirrors worldwide.

### Step 1: Create Project

1. Go to [SourceForge.net](https://sourceforge.net)
2. **Create Project**
3. Project name: `xnord-os`
4. Project URL: `https://xnord-os.sourceforge.io`
5. Description: Use the DistroSea description (see `docs/DISTROSEA.md`)
6. Category: **Operating System** → **Linux**
7. License: MIT
8. Complete registration

### Step 2: Upload Files

1. Go to your project → **Files**
2. Create release folder: `1.0` or `v1.0`
3. **Add Folder** → name it `1.0`
4. **Upload Files** to that folder:
   - `xnord-os-1.0-amd64.iso`
   - `xnord-os-1.0-amd64.iso.sha256`
   - `xnord-os-1.0-amd64.iso.sha256.sig` (optional, GPG signature)

### Step 3: Create Release

1. **Admin** → **Releases**
2. **Create New Release**
3. Version: `1.0`
4. Release notes: Paste changelog or link to GitHub releases
5. Select the uploaded files
6. **Publish**

### Step 4: Enable Download Stats

1. **Admin** → **Project Settings**
2. Enable **Download statistics**
3. Optional: Add a **Download** button to project homepage

### Download URL Format

- `https://sourceforge.net/projects/xnord-os/files/1.0/xnord-os-1.0-amd64.iso/download`
- Or: `https://downloads.sourceforge.net/project/xnord-os/1.0/xnord-os-1.0-amd64.iso`

---

## Option C: GitHub Releases

Best for version control and linking to your repo. 2GB file limit per asset.

### Step 1: Create Release

1. Go to your GitHub repo → **Releases** → **Create a new release**
2. Tag: `v1.0.0`
3. Title: `x-Nord OS 1.0`
4. Description: Use the launch changelog

### Step 2: Upload Assets

1. Drag and drop `xnord-os-1.0-amd64.iso` (if under 2GB, use compression if needed)
2. Upload `xnord-os-1.0-amd64.iso.sha256`
3. If ISO > 2GB: split or use external host and link in release notes

### Step 3: Publish

Click **Publish release**. Download URL:
`https://github.com/xnord-os/xnord-os/releases/download/v1.0.0/xnord-os-1.0-amd64.iso`

---

## Recommended: Hybrid Approach

- **Primary**: SourceForge or R2 (no file size limits, good for ISOs)
- **Secondary**: GitHub Releases (for checksums, release notes, and smaller assets)
- **Mirror**: Add torrent magnet link for community distribution

---

## Post-Upload Checklist

- [ ] Verify download URL works
- [ ] Test checksum: `sha256sum -c xnord-os-1.0-amd64.iso.sha256`
- [ ] Update README with download link
- [ ] Add download link to DistroSea submission
- [ ] Create torrent (optional): `mktorrent -a udp://tracker.opentrackr.org:1337 -o xnord-os-1.0.torrent xnord-os-1.0-amd64.iso`
