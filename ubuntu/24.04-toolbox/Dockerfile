FROM docker.io/ubuntu:24.04

RUN --mount=type=bind,source=extra-packages,target=/extra-packages \
  set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update ; \
    apt install -y --no-install-recommends $(paste extra-packages) ; \
    apt clean all ; \
    rm -rf /var/lib/apt/lists/*

RUN truncate -s0 /etc/machine-id