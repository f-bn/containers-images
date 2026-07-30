ARG VERSION="44"

FROM quay.io/fedora/fedora:${VERSION}

COPY --chown=0:0 --chmod=0644 \
  dnf.conf /etc/dnf/dnf.conf

RUN --mount=type=bind,source=extra-packages,target=/extra-packages \
  set -ex ; \
    dnf install -y --setopt=install_weak_deps=False $(paste extra-packages) ; \
    dnf clean all