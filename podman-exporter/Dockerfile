# --- Build stage ---
FROM docker.io/golang:1.24.6 AS build-binary

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="1.17.2"

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends \
    libbtrfs-dev \
    libdevmapper-dev \
    libgpgme-dev \
    libassuan-dev

WORKDIR /build

ADD --keep-git-dir \
  https://github.com/containers/prometheus-podman-exporter.git#v${VERSION} /build  

RUN make binary-remote

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG TARGETOS
ARG TARGETARCH

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/bin/remote/prometheus-podman-exporter /usr/bin/podman-exporter

RUN set -ex ; \
  addgroup -S -g 999 prometheus ; \
  adduser -S -D -s /bin/false -u 999 -G prometheus prometheus

ENV CONTAINER_HOST="unix:///run/podman/podman.sock"

USER prometheus

EXPOSE 9882/tcp

ENTRYPOINT [ "/usr/bin/podman-exporter" ]

LABEL \
  org.opencontainers.image.title="podman-exporter" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/podman-exporter" \
  org.opencontainers.image.description="Prometheus exporter for Podman environments exposing containers, pods, images, volumes and networks information" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"