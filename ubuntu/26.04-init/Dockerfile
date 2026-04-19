FROM docker.io/ubuntu:26.04

RUN --mount=type=bind,source=extra-packages,target=/extra-packages \
  set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update ; apt upgrade -y ; \
    apt install -y --allow-remove-essential coreutils-from-gnu coreutils-from-uutils- ; \
    apt install -y --no-install-recommends $(paste extra-packages) ; \
    apt clean all ; \
    rm -rf /var/lib/apt/lists/* /etc/ssh/ssh_host_*

COPY --chown=0:0 \
  ssh-keygen.service /etc/systemd/system/ssh-keygen.service
COPY --chown=0:0 \
  systemd/10-disable-sandboxing.conf /etc/systemd/system/service.d/10-disable-sandboxing.conf

RUN systemctl enable ssh-keygen.service
  
RUN truncate -s0 /etc/machine-id /var/lib/dbus/machine-id

ENV container="docker"

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT [ "/usr/lib/systemd/systemd" ]