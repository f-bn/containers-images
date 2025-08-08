ARG RELEASE="42"

FROM quay.io/fedora/fedora:${RELEASE}

COPY extra-packages /

RUN set -ex ; \
  dnf install -y --setopt=install_weak_deps=False $(<extra-packages) ; \
  dnf clean all ; \
  rm /extra-packages

LABEL \
  com.github.containers.toolbox="true" \
  org.opencontainers.image.title="coreos-toolbox" \
  org.opencontainers.image.version="${RELEASE}" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/coreos-toolbox" \
  org.opencontainers.image.description="Custom Fedora image including utilities and tools for debugging on Fedora CoreOS" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"