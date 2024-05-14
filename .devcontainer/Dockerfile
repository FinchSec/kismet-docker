FROM ubuntu:22.04

# Allow to build/run cross-platform containers
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install binfmt-support -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Add zsh
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install zsh -y && \
    rm -rf /var/lib/apt/lists/*

# Add vscode user
RUN useradd -m vscode
