#!/bin/bash
set -e

# Ensure Ollama CLI is in PATH
export PATH="$PATH:/usr/local/bin"

# Start Ollama server in the background
echo "Starting Ollama server..."
ollama serve &

# Function to check if Ollama server is ready
wait_for_server() {
    echo "Waiting for Ollama server to be ready..."
    until ollama list >/dev/null 2>&1; do
        echo -n "."
        sleep 2
    done
    echo "Ollama server is ready!"
}

# Wait for server to be ready
wait_for_server

# Pull required models if not already present
MODELS=("gpt-oss:120b")
for MODEL in "${MODELS[@]}"; do
    if ! ollama list | grep -q "$MODEL"; then
        echo "Pulling model: $MODEL..."
        ollama pull "$MODEL"
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
