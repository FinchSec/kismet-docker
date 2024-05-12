FROM docker:26-dind as base

RUN apk add --update --no-cache shadow curl

RUN useradd -m vscode && \
    usermod -aG docker vscode

RUN curl -fsSL https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-alpine.sh > script.sh && \
    chmod +x script.sh && \
    sed -i 's/libssl1.1/libssl3/' script.sh && \
    ./script.sh && \
    rm script.sh

COPY postStartCommand.sh /opt
RUN chmod +x /opt/postStartCommand.sh