# --- Build stage ---
FROM docker.io/node:24.12.0 AS build

ARG VERSION="1.0.1-beta.1"

WORKDIR /build

ADD https://github.com/jeffvli/feishin.git#v${VERSION} /build

RUN npm install -g pnpm

RUN set -ex ; \
  pnpm install ; \
  pnpm run build:web

# --- Final stage ---
FROM docker.io/nginx:1.29.4-alpine3.23

WORKDIR /app

COPY --from=build --chown=nginx:nginx /build/out/web /app/
COPY --chown=0:0 settings.js.template /etc/nginx/templates/settings.js.template
COPY --chown=0:0 nginx.conf.template  /etc/nginx/templates/default.conf.template

ENV FEISHIN_SERVER_TYPE=""
ENV FEISHIN_SERVER_NAME=""
ENV FEISHIN_SERVER_URL=""
ENV FEISHIN_SERVER_LOCK="false"
ENV FEISHIN_LISTEN_ADDR="0.0.0.0"
ENV FEISHIN_LISTEN_PORT=9180
ENV FEISHIN_PUBLIC_PATH="/"

USER nginx

EXPOSE 9180/tcp