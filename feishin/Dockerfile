# --- Build stage ---
FROM docker.io/node:24.13.1 AS build

ARG VERSION="1.6.0"

WORKDIR /build

ADD https://github.com/jeffvli/feishin.git#v${VERSION} /build

RUN npm install -g pnpm

RUN set -ex ; \
  pnpm install ; \
  pnpm run build:web

# --- Final stage ---
FROM docker.io/nginx:1.29.5-alpine3.23

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
ENV FEISHIN_ANALYTICS_DISABLED="false"

USER nginx

EXPOSE 9180/tcp