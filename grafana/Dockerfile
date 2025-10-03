# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=12.1.0

WORKDIR /build

ADD https://dl.grafana.com/oss/release/grafana-${VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz \
  /build/grafana.tar.gz
ADD https://dl.grafana.com/oss/release/grafana-${VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz.sha256 \
  /build/grafana.tar.gz.sha256

RUN set -ex ; \
  echo "$(cat grafana.tar.gz.sha256) grafana.tar.gz" | sha256sum -c ; \
  tar -xvzf /build/grafana.tar.gz --strip-components=1

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VERSION=12.1.0

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/bin /usr/share/grafana/bin
COPY --from=build --chown=0:0 --chmod=0755 \
  /build/conf /usr/share/grafana/conf
COPY --from=build --chown=0:0 --chmod=0755 \
  /build/docs /usr/share/grafana/docs
COPY --from=build --chown=0:0 --chmod=0755 \
  /build/npm-artifacts /usr/share/grafana/npm-artifacts
COPY --from=build --chown=0:0 --chmod=0755 \
  /build/plugins-bundled /usr/share/grafana/plugins-bundled
COPY --from=build --chown=0:0 --chmod=0755 \
  /build/storybook /usr/share/grafana/storybook
COPY --from=build --chown=0:0 --chmod=0755 \
  /build/public /usr/share/grafana/public

COPY --chown=0:0 --chmod=0644 \
  grafana.default.ini /etc/grafana/grafana.ini

RUN set -ex ; \
  addgroup -S -g 999 grafana ; \
  adduser -S -D -H -s /bin/false -u 999 -G grafana grafana

RUN set -ex ; \
  mkdir -p /etc/grafana /var/lib/grafana ; \
  chown root:grafana /etc/grafana ; \
  chown grafana:grafana /var/lib/grafana ; \
  chmod 750 /etc/grafana /var/lib/grafana

USER grafana

EXPOSE 3000/tcp

VOLUME [ "/var/lib/grafana" ]

WORKDIR /usr/share/grafana

ENTRYPOINT [ "/usr/share/grafana/bin/grafana" ]

CMD [ "server", \
      "--config=/etc/grafana/grafana.ini" ]

LABEL \
  org.opencontainers.image.title="grafana" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/grafana" \
  org.opencontainers.image.description="The open and composable observability and data visualization platform" \
  org.opencontainers.image.licenses="AGPL-3.0-or-later" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"