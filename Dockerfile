FROM seefkordia/ollama-openwebui-base:1.0.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
        htop \
        git \
        build-essential \
        cmake \
        libncurses5-dev \
        libncursesw5-dev \
        libudev-dev \
        libsystemd-dev \
        libdrm-dev \
        curl \
        unzip \
        wget \
        sudo \
    && rm -rf /var/lib/apt/lists/*

# Build and install nvtop
RUN git clone https://github.com/Syllo/nvtop.git /tmp/nvtop && \
    mkdir /tmp/nvtop/build && cd /tmp/nvtop/build && \
    cmake .. -DNVIDIA_ONLY=ON && make && \
    mv src/nvtop /usr/local/bin/ && chmod +x /usr/local/bin/nvtop && \
    cd / && rm -rf /tmp/nvtop

# Download and install Ollama CLI
RUN wget -O /tmp/ollama.tgz https://ollama.com/download/ollama-linux-amd64.tgz && \
    mkdir -p /usr/local/bin/ollama_tmp && \
    tar -xzf /tmp/ollama.tgz -C /usr/local/bin/ollama_tmp && \
    find /usr/local/bin/ollama_tmp -type f -name 'ollama' -exec mv {} /usr/local/bin/ollama \; && \
    chmod +x /usr/local/bin/ollama && \
    rm -rf /tmp/ollama.tgz /usr/local/bin/ollama_tmp

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose OpenWebUI port
EXPOSE 8080

# Use the custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default CMD to start OpenWebUI
CMD ["/app/start.sh"]
