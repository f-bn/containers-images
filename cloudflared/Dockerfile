# --- Build stage ---
FROM docker.io/golang:1.22.5 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="2025.1.0"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV CONTAINER_BUILD=1

WORKDIR /build

ADD --keep-git-dir https://github.com/cloudflare/cloudflared.git#${VERSION} /build

RUN make cloudflared

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=755 \
  /build/cloudflared /usr/bin/cloudflared

RUN mkdir -p /etc/cloudflared

ENV NO_AUTOUPDATE=true

USER nonroot

ENTRYPOINT [ "/usr/bin/cloudflared" ]

CMD [ "version" ]

LABEL \
  org.opencontainers.image.title="cloudflared" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/cloudflared" \
  org.opencontainers.image.description="Cloudflare Tunnel client" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"
