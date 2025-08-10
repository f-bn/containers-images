# --- Build stage ---
FROM docker.io/golang:1.24.5 AS build

ARG TARGETOS
ARG TARGETARCH
ARG CADDY_VERSION="2.10.0"

WORKDIR /build

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.5

RUN xcaddy build "v${CADDY_VERSION}" --output docker-api-proxy

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/docker-api-proxy /usr/bin/docker-api-proxy

COPY Caddyfile /etc/Caddyfile

ENTRYPOINT [ "/usr/bin/docker-api-proxy" ]

CMD [ "run", "--config", "/etc/Caddyfile" ]

LABEL \
  org.opencontainers.image.title="docker-api-proxy" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/traefik" \
  org.opencontainers.image.description="Custom Caddy image for limiting applications access to the Docker API through the socket" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"