#!/bin/bash
# Install Ollama for x-Nord OS (run in chroot or on live system)
set -e

if ! command -v ollama &>/dev/null; then
    echo "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

# Create ollama user if not exists
if ! id ollama &>/dev/null; then
    useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama 2>/dev/null || true
fi

# Install systemd service
cp "$(dirname "$0")/../packages/ollama/ollama.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable ollama
systemctl start ollama 2>/dev/null || true

echo "Ollama installed. Run 'ollama pull llama3.2:3b' to download the default model."
