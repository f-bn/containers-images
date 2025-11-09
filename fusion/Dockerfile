# --- Build stage ---
FROM docker.io/node:24.11.0 AS build-webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="0.9.8"

ENV VITE_FUSION_VERSION="${VERSION}"

ADD --keep-git-dir \
  https://github.com/0x2E/fusion.git#v${VERSION} /build  

WORKDIR /build/frontend

RUN npm install -g pnpm

RUN set -ex ; \
  pnpm install ; \
  pnpm run build

# --- Build stage ---
FROM docker.io/golang:1.25.4 AS build-binary

ARG TARGETOS
ARG TARGETARCH

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

COPY --from=build-webui /build /build

WORKDIR /build 

RUN set -ex ; \
  mkdir -p /build/dist ; \
  go build -ldflags "-s -w -extldflags '-static'" -o "./dist/fusion" ./cmd/server/*

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

ENV DB="/var/lib/fusion/fusion.db"

EXPOSE 8080/tcp

VOLUME [ "/var/lib/fusion" ]

ENTRYPOINT [ "/usr/bin/fusion" ]