#!/bin/bash
set -e

# Ensure Ollama CLI is in PATH
export PATH="$PATH:/usr/local/bin"

# Start Ollama server with GPU support
echo "Starting Ollama server with GPU support..."
ollama serve --gpu &
sleep 10

# Pull required models if not already present (GPU-enabled)
MODELS=("gpt-oss:120b")
for MODEL in "${MODELS[@]}"; do
    if ! ollama list | grep -q "$MODEL"; then
        echo "Pulling model: $MODEL with GPU..."
        ollama pull "$MODEL" --gpu
    fi
done

# Install Open WebUI if needed
echo "Installing Open WebUI..."
pip install --no-cache-dir open-webui

# Set Gradio server to listen on all interfaces
export GRADIO_SERVER_NAME="0.0.0.0"

# Start Open WebUI
echo "Starting Open WebUI..."
exec "$@"
