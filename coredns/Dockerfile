# --- Build stage ---
FROM docker.io/golang:1.20 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.11.1

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends libcap2-bin

WORKDIR /build

RUN git clone --single-branch --branch v${VERSION} https://github.com/coredns/coredns.git /build
RUN set -ex ; \
  go build -v -ldflags="-s -w -X github.com/coredns/coredns/coremain.GitCommit=$(git rev-parse HEAD)" -o /build/bin/coredns ; \
  setcap cap_net_bind_service=+ep /build/bin/coredns

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VERSION

COPY --from=build --chmod=755 /build/bin/coredns /usr/bin/coredns

USER nonroot

EXPOSE 53/tcp 53/udp

ENTRYPOINT [ "/usr/bin/coredns" ]

LABEL \
  org.opencontainers.image.title="CoreDNS" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/coredns" \
  org.opencontainers.image.description="CoreDNS is a DNS server that chains plugins" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"