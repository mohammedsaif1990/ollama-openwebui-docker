# Use the working base that contains CUDA & GPU support
FROM thelocallab/ollama-openwebui:latest

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

# Copy custom entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the UI port
EXPOSE 8080

# Set the custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default CMD to start OpenWebUI
CMD ["/app/start.sh"]
