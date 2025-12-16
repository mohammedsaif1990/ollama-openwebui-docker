#!/bin/bash
set -e

# Ensure Ollama CLI is in PATH
export PATH="$PATH:/usr/local/bin"

# Any extra commands at container start
echo "Container is starting..."

# Execute the default CMD (OpenWebUI)
exec "$@"