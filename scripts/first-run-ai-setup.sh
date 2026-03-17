#!/bin/bash
# First-run AI setup - prompt user to download Llama model
# Run from autostart or desktop session

CONFIG_DIR="${HOME}/.local/share/xnord-ai"
CONFIG_FILE="${CONFIG_DIR}/first-run-done"

mkdir -p "$CONFIG_DIR"

if [ -f "$CONFIG_FILE" ]; then
    exit 0
fi

# Check if Ollama is running
if ! curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:11434/api/tags 2>/dev/null | grep -q 200; then
    echo "x-Nord AI: Ollama not running. Start with: ollama serve"
    exit 0
fi

# Check if model exists
if ! ollama list 2>/dev/null | grep -q "llama3.2:3b"; then
    echo "x-Nord AI: Downloading Llama 3.2 3B model (~2GB)..."
    ollama pull llama3.2:3b
fi

touch "$CONFIG_FILE"
echo "x-Nord AI: Ready."
