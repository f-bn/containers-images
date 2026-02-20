# --- Build stage ---
FROM docker.io/node:24.13.1 AS build-webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="1.0.0"

ADD --keep-git-dir \
  https://github.com/0x2E/fusion.git#v${VERSION} /build  

WORKDIR /build/frontend

RUN npm install -g pnpm

ENV VITE_FUSION_VERSION="${VERSION}"

RUN set -ex ; \
  pnpm install --frozen-lockfile ; \
  pnpm run build

# --- Build stage ---
FROM docker.io/golang:1.25.7 AS build-binary

ARG TARGETOS
ARG TARGETARCH

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

COPY --from=build-webui /build /build

WORKDIR /build/backend

RUN cp -R /build/frontend/dist/. /build/backend/internal/web/dist/

RUN set -ex ; \
  mkdir -p /build/dist ; \
  go build -trimpath -ldflags "-s -w -extldflags '-static'" -o "/build/dist/fusion" ./cmd/fusion

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/dist/fusion /usr/bin/fusion

RUN set -ex ; \
  addgroup -S -g 999 fusion ; \
  adduser -S -D -H -s /bin/false -u 999 -G fusion fusion

RUN set -ex ; \
  mkdir -p /var/lib/fusion ; \
  chown fusion:fusion /var/lib/fusion ; \
  chmod 755 /var/lib/fusion

USER fusion

ENV FUSION_DB_PATH="/var/lib/fusion/fusion.db"

EXPOSE 8080/tcp

VOLUME [ "/var/lib/fusion" ]

ENTRYPOINT [ "/usr/bin/fusion" ]