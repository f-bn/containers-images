# --- Build stage ---
FROM docker.io/golang:1.25.5 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="0.30.0"

ADD --keep-git-dir \
  https://github.com/prometheus/alertmanager.git#v${VERSION} /build

COPY promu.yml /build/.promu.yml

WORKDIR /build

RUN make common-build

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/alertmanager /usr/bin/alertmanager
COPY --from=build --chown=0:0 --chmod=0755 \
  /build/amtool /usr/bin/amtool
COPY --from=build --chown=0:0 --chmod=0644 \
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

USER prometheus

EXPOSE 9093/tcp

VOLUME [ "/var/lib/alertmanager" ]

WORKDIR /etc/alertmanager

ENTRYPOINT [ "/usr/bin/alertmanager" ]

CMD [ "--config.file=/etc/alertmanager/alertmanager.yml", \
      "--storage.path=/var/lib/alertmanager" ]