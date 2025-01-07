# --- Build stage ---
FROM docker.io/golang:1.23 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=0.24

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV GO_SKIP_GENERATE=1
ENV GO_BUILD_FLAGS="-tags static -v "
ENV BIN_OUT_DIR="/build"

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends libcap2-bin

WORKDIR /build

ADD --keep-git-dir https://github.com/0xERR0R/blocky.git#v${VERSION} /build

RUN set -ex ; \
  make build ; \
  setcap 'cap_net_bind_service=+ep' /build/blocky

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=755 \
  /build/blocky /usr/bin/blocky

RUN mkdir -p /etc/blocky

ENV BLOCKY_CONFIG_FILE=/etc/blocky/config.yml

USER nonroot

EXPOSE 53/tcp 53/udp 443/tcp 4000/tcp

ENTRYPOINT [ "/usr/bin/blocky" ]

LABEL \
  org.opencontainers.image.title="blocky" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/blocky" \
  org.opencontainers.image.description="Fast and lightweight DNS proxy as ad-blocker for local network with many features" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"