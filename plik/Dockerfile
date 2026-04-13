# --- Build stage ---
FROM docker.io/node:24.14.1-bookworm-slim AS build-webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="1.4.2"

ADD --keep-git-dir \
  https://github.com/root-gg/plik.git#${VERSION} /build

WORKDIR /build/webapp

RUN set -ex ; \
  npm ci ; \
  npm run build

# --- Build stage ---
FROM docker.io/golang:1.26.2 AS build-binary

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="1.4.2"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=1

COPY --from=build-webui /build /build

WORKDIR /build/server

RUN set -ex ; \
  mkdir -p /build/dist ; \
  go build -ldflags="-s -w \
      -extldflags='-static' \
      -X github.com/root-gg/plik/server/common.buildInfoString=$($PWD/gen_build_info.sh base64)" \
    -tags osusergo,netgo,sqlite_omit_load_extension -o /build/dist/plikd .

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/dist/plikd /usr/bin/plikd

RUN set -ex ; \
  addgroup -S -g 999 plik ; \
  adduser -S -D -H -s /bin/false -u 999 -G plik plik

RUN set -ex ; \
  install -o root -g plik -m 0750 -d /etc/plik ; \
  install -o plik -g plik -m 0700 -d /var/lib/plik

ENV PLIKD_CONFIG="/etc/plik/plikd.cfg"
ENV PLIKD_WEBAPP_DIRECTORY="/usr/share/plik"

COPY --chown=root:plik --chmod=0640 \
  plikd.default.cfg ${PLIKD_CONFIG}
COPY --from=build-webui --chown=plik:plik \
  /build/webapp/dist ${PLIKD_WEBAPP_DIRECTORY}

USER plik

EXPOSE 8080/tcp

WORKDIR /etc/plik

ENTRYPOINT [ "/usr/bin/plikd" ]