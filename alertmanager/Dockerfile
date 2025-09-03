# --- Build stage ---
FROM docker.io/node:24.6.0 AS build-webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="0.28.1"

ADD --keep-git-dir \
  https://github.com/prometheus/alertmanager.git#v${VERSION} /build  

WORKDIR /build

RUN make assets-compress

# --- Build stage ---
FROM docker.io/golang:1.24.6 AS build-binary

COPY --from=build-webui /build /build
COPY promu.yml /build/.promu.yml

WORKDIR /build

RUN make common-build

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/alertmanager /usr/bin/alertmanager
COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/amtool /usr/bin/amtool
COPY --from=build-binary --chown=0:0 --chmod=0644 \
  /build/examples/ha/alertmanager.yml /etc/alertmanager/alertmanager.yml

RUN set -ex ; \
  addgroup -S -g 999 prometheus ; \
  adduser -S -D -H -s /bin/false -u 999 -G prometheus prometheus

RUN set -ex ; \
  mkdir -p /etc/alertmanager /var/lib/alertmanager ; \
  chown root:prometheus /etc/alertmanager ; \
  chmod 750 /etc/alertmanager ; \
  chown prometheus:prometheus /var/lib/alertmanager ; \
  chmod 755 /var/lib/alertmanager

RUN apk add --no-cache curl

USER prometheus

EXPOSE 9093/tcp

VOLUME [ "/var/lib/alertmanager" ]

WORKDIR /etc/alertmanager

ENTRYPOINT [ "/usr/bin/alertmanager" ]

CMD [ "--config.file=/etc/alertmanager/alertmanager.yml", \
      "--storage.path=/var/lib/alertmanager" ]

LABEL \
  org.opencontainers.image.title="alertmanager" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/alertmanager" \
  org.opencontainers.image.description="Prometheus Alertmanager" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"