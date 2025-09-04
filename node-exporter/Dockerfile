# --- Build stage ---
FROM docker.io/golang:1.24.6 AS build

ARG VERSION="1.9.1"

WORKDIR /build

ADD --keep-git-dir \
  https://github.com/prometheus/node_exporter.git#v${VERSION} /build/

COPY promu.yml /build/.promu.yml

RUN make common-build

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/node-exporter /usr/bin/node-exporter

RUN set -ex ; \
  addgroup -S -g 999 prometheus ; \
  adduser -S -D -H -s /bin/false -u 999 -G prometheus prometheus

USER prometheus

EXPOSE 9100/tcp

ENTRYPOINT [ "/usr/bin/node-exporter" ]

LABEL \
  org.opencontainers.image.title="node-exporter" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/node-exporter" \
  org.opencontainers.image.description="Exporter for machine metrics" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"