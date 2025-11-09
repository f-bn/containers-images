# --- Build stage ---
FROM docker.io/golang:1.25.4 AS build

ARG VERSION="1.10.2"

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