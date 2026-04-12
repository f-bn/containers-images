# --- Build stage ---
FROM docker.io/node:24.14.1-bookworm-slim AS build-webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="2.5.0"

ADD https://github.com/pocket-id/pocket-id.git#v${VERSION} /build

WORKDIR /build

RUN set -ex ; \
  corepack enable ; \
  pnpm --filter pocket-id-frontend install --frozen-lockfile ; \
  pnpm --filter pocket-id-frontend run build

# --- Build stage ---
FROM docker.io/golang:1.26.2 AS build-binary

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="2.5.0"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

COPY --from=build-webui /build /build

WORKDIR /build/backend

RUN set -ex ; \
  mkdir -p /build/dist ; \
  go build -ldflags="-s -w \
      -buildid=${VERSION} \
      -X github.com/pocket-id/pocket-id/backend/internal/common.Version=${VERSION}" \
    -trimpath -o /build/dist/pocket-id ./cmd

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/dist/pocket-id /usr/bin/pocket-id

RUN set -ex ; \
  addgroup -S -g 999 pocket-id  ; \
  adduser -S -D -H -s /bin/false -u 999 -G pocket-id pocket-id

RUN install -o pocket-id -g pocket-id -m 0700 -d /var/lib/pocket-id

ENV APP_ENV=production
ENV DB_CONNECTION_STRING=/var/lib/pocket-id/pocket-id.db
ENV UPLOAD_PATH=/var/lib/pocket-id/uploads
ENV GEOLITE_DB_PATH=/var/lib/pocket-id/GeoLite2-City.mmdb
ENV VERSION_CHECK_DISABLED=true

USER pocket-id

EXPOSE 1411/tcp

VOLUME [ "/var/lib/pocket-id" ]

ENTRYPOINT [ "/usr/bin/pocket-id" ]