FROM docker.io/ubuntu:24.04

COPY extra-packages /

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends $(paste extra-packages) ; \
  apt clean all ; \
  rm -rf /var/lib/apt/lists/* ; \
  rm /extra-packages

# Enable bash completion in exec shell
RUN tee -a /etc/bash.bashrc > /dev/null <<'EOF'
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
EOF

RUN truncate -s0 /etc/machine-id

ENV container="docker"

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT [ "/usr/lib/systemd/systemd" ]

LABEL \
  org.opencontainers.image.title="ubuntu" \
  org.opencontainers.image.version="24.04" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/ubuntu/24.04-init" \
  org.opencontainers.image.description="Custom Ubuntu 24.04 system container image" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"