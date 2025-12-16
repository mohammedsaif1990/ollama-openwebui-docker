#!/bin/bash
set -e

# Ensure Ollama CLI is in PATH
export PATH="$PATH:/usr/local/bin"

# Start Ollama server in background
echo "Starting Ollama server..."
ollama serve &

# Wait a few seconds for the server to be ready
sleep 10

# Pull required models if not already present
MODELS=("llama3:8b" "qwen2.5-coder:1.5b")
for MODEL in "${MODELS[@]}"; do
    if ! ollama list | grep -q "$MODEL"; then
        echo "Pulling model: $MODEL..."
        ollama pull "$MODEL"
    fi
done

# Any extra startup commands
echo "Container is starting..."

# Execute default CMD (OpenWebUI)
exec "$@"
