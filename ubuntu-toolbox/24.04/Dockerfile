FROM quay.io/toolbx/ubuntu-toolbox:24.04

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends \
    direnv \
    fzf \
    fq \
    httpie \
    jq \
    neovim \
    wget \
    whois \
    yq \
    zstd ; \
  apt clean all ; \
  rm -rf /var/lib/apt/lists/*

LABEL \
  org.opencontainers.image.title="ubuntu-toolbox" \
  org.opencontainers.image.version="24.04" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/ubuntu-toolbox" \
  org.opencontainers.image.description="Custom Ubuntu toolbox image based on toolbx/ubuntu-toolbox image" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"