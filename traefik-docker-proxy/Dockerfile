# --- Build stage ---
FROM docker.io/golang:1.23.5 AS build

ARG TARGETOS
ARG TARGETARCH
ARG CADDY_VERSION="2.9.1"

WORKDIR /build

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.4

RUN xcaddy build "v${CADDY_VERSION}" --output traefik-docker-proxy

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/traefik-docker-proxy /usr/bin/traefik-docker-proxy

COPY Caddyfile /etc/Caddyfile

ENTRYPOINT [ "/usr/bin/traefik-docker-proxy" ]

CMD [ "run", "--config", "/etc/Caddyfile" ]

LABEL \
  org.opencontainers.image.title="traefik-docker-proxy" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/traefik" \
  org.opencontainers.image.description="Custom Caddy image for limiting Traefik access to the Docker API through the socket" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"