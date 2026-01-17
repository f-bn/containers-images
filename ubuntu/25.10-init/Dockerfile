FROM docker.io/ubuntu:25.10

COPY --chown=0:0 \
  extra-packages /extra-packages
COPY --chown=0:0 \
  ssh-keygen.service /etc/systemd/system/ssh-keygen.service

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends $(paste extra-packages) ; \
  apt remove --allow-remove-essential -y coreutils-from-uutils ; \
  apt clean all ; \
  rm -rf /var/lib/apt/lists/* ; \
  rm /extra-packages /etc/ssh/ssh_host_*

RUN systemctl enable ssh-keygen.service
  
RUN truncate -s0 /etc/machine-id /var/lib/dbus/machine-id

ENV container="docker"

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT [ "/usr/lib/systemd/systemd" ]