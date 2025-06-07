# --- Build stage ---
FROM docker.io/node:18-bookworm-slim AS build

ARG VERSION="0.14.0"

WORKDIR /build

ADD https://github.com/jeffvli/feishin.git#v${VERSION} /build

RUN npm install --legacy-peer-deps --ignore-scripts
RUN npm run build:web

# --- Final stage ---
FROM docker.io/nginx:1.28.0
WORKDIR /app

COPY --from=build --chown=nginx:nginx /build/release/app/dist/web /app/
COPY --chown=0:0 settings.js.template /etc/nginx/templates/settings.js.template
COPY --chown=0:0 nginx.conf.template  /etc/nginx/templates/default.conf.template

ENV FEISHIN_SERVER_TYPE=""
ENV FEISHIN_SERVER_NAME=""
ENV FEISHIN_SERVER_URL=""
ENV FEISHIN_SERVER_LOCK="false"
ENV FEISHIN_LISTEN_ADDR="0.0.0.0"
ENV FEISHIN_LISTEN_PORT=9180
ENV FEISHIN_PUBLIC_PATH="/"

EXPOSE 9180/tcp

LABEL \
  org.opencontainers.image.title="feishin" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/feishin" \
  org.opencontainers.image.description="A modern self-hosted music player" \
  org.opencontainers.image.licenses="GPL-3.0-or-later" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"