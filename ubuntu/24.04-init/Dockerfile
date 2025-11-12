FROM docker.io/ubuntu:24.04

COPY extra-packages /

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends $(paste extra-packages) ; \
  apt clean all ; \
  rm -rf /var/lib/apt/lists/* ; \
  rm /extra-packages

RUN truncate -s0 /etc/machine-id

ENV container="docker"

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT [ "/usr/lib/systemd/systemd" ]