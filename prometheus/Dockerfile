# --- Build stage ---
FROM docker.io/node:24.6.0 AS build-webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="3.5.0"

ADD --keep-git-dir \
  https://github.com/prometheus/prometheus.git#v${VERSION} /build  

WORKDIR /build

RUN make assets

# --- Build stage ---
FROM docker.io/golang:1.24.6 AS build-binary

COPY --from=build-webui /build /build
COPY plugins.yml /build/plugins.yml
COPY promu.yml /build/.promu.yml

WORKDIR /build

RUN set -ex ; \ 
  go generate -tags plugins ./plugins ; \
  SKIP_UI_BUILD=true make build

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/prometheus /usr/bin/prometheus
COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/promtool /usr/bin/promtool
COPY --from=build-binary --chown=0:0 --chmod=0644 \
  /build/documentation/examples/prometheus.yml /etc/prometheus/prometheus.yml

RUN set -ex ; \
  addgroup -S -g 999 prometheus ; \
  adduser -S -D -H -s /bin/false -u 999 -G prometheus prometheus

RUN set -ex ; \
  mkdir -p /etc/prometheus /var/lib/prometheus ; \
  chown root:prometheus /etc/prometheus ; \
  chmod 750 /etc/prometheus ; \
  chown prometheus:prometheus /var/lib/prometheus ; \
  chmod 755 /var/lib/prometheus

USER prometheus

EXPOSE 9090/tcp

VOLUME [ "/var/lib/prometheus" ]

WORKDIR /etc/prometheus

ENTRYPOINT [ "/usr/bin/prometheus" ]

CMD [ "--config.file=/etc/prometheus/prometheus.yml", \
      "--storage.tsdb.path=/var/lib/prometheus" ]

LABEL \
  org.opencontainers.image.title="prometheus" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/prometheus" \
  org.opencontainers.image.description="The Prometheus monitoring system and time series database" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"