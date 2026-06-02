FROM docker.io/fedora:44

COPY --chown=0:0 --chmod=0644 \
  dnf.conf /etc/dnf/dnf.conf

RUN --mount=type=bind,source=extra-packages,target=/extra-packages \
  set -ex ; \
    dnf -y swap glibc-minimal-langpack glibc-langpack-en ; \
    dnf -y swap coreutils-single coreutils-full ; \
    dnf upgrade -y; \
    dnf install -y --setopt=install_weak_deps=False $(paste extra-packages) ; \
    dnf clean all
