FROM docker.io/fedora:44

COPY --chown=0:0 --chmod=0644 \
  dnf.conf /etc/dnf/dnf.conf

RUN --mount=type=bind,source=extra-packages,target=/extra-packages \
  set -ex ; \
    dnf upgrade -y; \
    dnf install -y --setopt=install_weak_deps=False $(paste extra-packages) ; \
    dnf clean all ; \
    rm -f /etc/ssh/ssh_host_*

RUN set -ex ; \
  systemctl disable sshd.service ; \
  systemctl enable sshd.socket

COPY --chown=0:0 \
  systemd/10-disable-sandboxing.conf /etc/systemd/system/service.d/10-disable-sandboxing.conf

RUN truncate -s0 /etc/machine-id

ENV container="docker"

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT [ "/usr/lib/systemd/systemd" ]