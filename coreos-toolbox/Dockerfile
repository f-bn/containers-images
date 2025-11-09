ARG VERSION="42"

FROM quay.io/fedora/fedora:${VERSION}

COPY extra-packages /

RUN set -ex ; \
  dnf install -y --setopt=install_weak_deps=False $(<extra-packages) ; \
  dnf clean all ; \
  rm /extra-packages