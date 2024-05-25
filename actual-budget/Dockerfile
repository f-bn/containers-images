# --- Build stage ---
FROM docker.io/node:18.20.3 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=24.5.0

WORKDIR /build

RUN git clone --single-branch --branch v${VERSION} https://github.com/actualbudget/actual-server.git /build

RUN yarn workspaces focus --all --production

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build /build/node_modules /usr/share/actual-budget/node_modules
COPY --from=build /build/src /usr/share/actual-budget/src
COPY --from=build /build/migrations /usr/share/actual-budget/migrations
COPY --from=build /build/package.json /build/app.js /usr/share/actual-budget/

RUN set -ex ; \
  mkdir -p /data ; \
  chown nonroot:nonroot /data

RUN apk add --no-cache nodejs-18

USER nonroot

EXPOSE 5006/tcp

VOLUME [ "/data" ]

ENTRYPOINT [ "/usr/bin/node", "/usr/share/actual-budget/app.js" ]

LABEL \
  org.opencontainers.image.title="actual-budget" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/actual-budget" \
  org.opencontainers.image.description="A local-first personal finance app" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"