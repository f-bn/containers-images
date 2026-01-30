FROM docker.io/ubuntu:25.10

COPY --chown=0:0 \
  extra-packages /extra-packages

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends $(paste extra-packages) ; \
  apt remove --allow-remove-essential -y coreutils-from-uutils ; \
  apt clean all ; \
  rm -rf /var/lib/apt/lists/* ; \
  rm /extra-packages

RUN truncate -s0 /etc/machine-id /var/lib/dbus/machine-id