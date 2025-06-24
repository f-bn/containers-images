# --- Build stage ---
FROM docker.io/node:23-bookworm-slim AS build-web

ARG VERSION="0.14.0"

WORKDIR /build

ADD https://github.com/jeffvli/feishin.git#v${VERSION} /build

RUN npm install -g pnpm

RUN set -ex ; \
  pnpm install ; \
  pnpm run build:web

# --- Build stage ---
FROM docker.io/golang:1.24.4 AS build-binary

ARG XCADDY_VERSION="0.4.4"
ARG CADDY_VERSION="2.10.0"

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v${XCADDY_VERSION}

WORKDIR /build

COPY --from=build-web /build/out/web/ /build/web/

RUN xcaddy build v${CADDY_VERSION} \
  --output caddy-feishin \
  --embed ./web

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-binary --chmod=755 \
  /build/caddy-feishin /usr/bin/caddy-feishin
COPY --chown=0:0 --chmod=755 \
  docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
COPY --chown=0:0 Caddyfile.tmpl /etc/caddy/templates/Caddyfile.tmpl
COPY --chown=0:0 settings.js.tmpl /etc/caddy/templates/settings.js.tmpl

ENV FEISHIN_SERVER_TYPE=""
ENV FEISHIN_SERVER_NAME=""
ENV FEISHIN_SERVER_URL=""
ENV FEISHIN_SERVER_LOCK="false"
ENV FEISHIN_LISTEN_ADDR="localhost"
ENV FEISHIN_LISTEN_PORT=9180
ENV FEISHIN_PUBLIC_PATH="/"

RUN apk --no-cache add gettext gosu

EXPOSE 9180/tcp

WORKDIR /etc/caddy/conf.d

ENTRYPOINT [ "/usr/bin/docker-entrypoint.sh" ]

CMD [ "/usr/bin/caddy-feishin", "run" ]

LABEL \
  org.opencontainers.image.title="feishin" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/feishin" \
  org.opencontainers.image.description="A modern self-hosted music player" \
  org.opencontainers.image.licenses="GPL-3.0-or-later" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"