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

# Install Ollama CLI at build time
RUN wget -O /tmp/ollama.tgz https://ollama.com/download/ollama-linux-amd64.tgz && \
    mkdir -p /usr/local/bin/ollama_tmp && \
    tar -xzf /tmp/ollama.tgz -C /usr/local/bin/ollama_tmp && \
    mv /usr/local/bin/ollama_tmp/ollama /usr/local/bin/ollama && \
    chmod +x /usr/local/bin/ollama && \
    rm -rf /tmp/ollama.tgz /usr/local/bin/ollama_tmp

# Pre-pull models (e.g., llama3:8b)
RUN /usr/local/bin/ollama pull llama3:8b

# Optional: Copy entrypoint to run extra commands
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set CMD to OpenWebUI start script from base image
CMD ["/app/start.sh"]