FROM ubuntu:22.04

# Allow to build/run cross-platform containers
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install binfmt-support -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Add zsh
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install zsh -y && \
    rm -rf /var/lib/apt/lists/*

# Add vscode user
RUN useradd -m vscode
