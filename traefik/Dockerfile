# --- Build stage ---
FROM docker.io/node:22.13-bookworm-slim AS build-webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="3.3.5"

ADD https://github.com/traefik/traefik.git#v${VERSION} /build

WORKDIR /build/webui

RUN set -ex ; \
  yarn install ; \
  yarn build

# --- Build stage ---
FROM docker.io/golang:1.24.2 AS build-binary

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="3.3.5"
ARG CODENAME="saint-nectaire"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0
ENV GOGC="off"

COPY --from=build-webui /build /build

WORKDIR /build

RUN set -ex ; \
  mkdir -p /build/dist ; \
  go build -ldflags "-s -w \
      -X github.com/traefik/traefik/v3/pkg/version.Version=${VERSION} \
      -X github.com/traefik/traefik/v3/pkg/version.BuildDate=$(date -u '+%Y-%m-%d_%I:%M:%S%p') \
      -X github.com/traefik/traefik/v3/pkg/version.Codename=${CODENAME}" \
    -installsuffix nocgo -o "./dist/traefik" ./cmd/traefik

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/dist/traefik /usr/bin/traefik

RUN set -ex ; \
  mkdir -p /etc/traefik ; \
  chown nonroot:nonroot /etc/traefik

USER nonroot

EXPOSE 80/tcp 443/tcp

WORKDIR /etc/traefik

ENTRYPOINT [ "/usr/bin/traefik" ]

LABEL \
  org.opencontainers.image.title="traefik" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/traefik" \
  org.opencontainers.image.description="The Cloud Native Application Proxy" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"