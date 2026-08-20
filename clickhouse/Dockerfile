# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG VERSION="26.7.3.19"
ARG CHANNEL="stable"

WORKDIR /build

ADD https://packages.clickhouse.com/tgz/${CHANNEL}/clickhouse-common-static-${VERSION}-amd64.tgz \
  /build/clickhouse-common-static-${VERSION}-amd64.tgz
ADD https://packages.clickhouse.com/tgz/${CHANNEL}/clickhouse-common-static-${VERSION}-amd64.tgz.sha512 \
  /build/clickhouse-common-static-${VERSION}-amd64.tgz.sha512

RUN set -ex ; \
  cat clickhouse-common-static-${VERSION}-amd64.tgz.sha512 | sha512sum -c ; \
  tar -xvzf clickhouse-common-static-${VERSION}-amd64.tgz --strip-components=1

ADD https://packages.clickhouse.com/tgz/${CHANNEL}/clickhouse-server-${VERSION}-amd64.tgz \
  /build/clickhouse-server-${VERSION}-amd64.tgz
ADD https://packages.clickhouse.com/tgz/${CHANNEL}/clickhouse-server-${VERSION}-amd64.tgz.sha512 \
  /build/clickhouse-server-${VERSION}-amd64.tgz.sha512

RUN set -ex ; \
  cat clickhouse-server-${VERSION}-amd64.tgz.sha512 | sha512sum -c ; \
  tar -xvzf clickhouse-server-${VERSION}-amd64.tgz --strip-components=1

ADD https://packages.clickhouse.com/tgz/${CHANNEL}/clickhouse-client-${VERSION}-amd64.tgz \
  /build/clickhouse-client-${VERSION}-amd64.tgz
ADD https://packages.clickhouse.com/tgz/${CHANNEL}/clickhouse-client-${VERSION}-amd64.tgz.sha512 \
  /build/clickhouse-client-${VERSION}-amd64.tgz.sha512

RUN set -ex ; \
  cat clickhouse-client-${VERSION}-amd64.tgz.sha512 | sha512sum -c ; \
  tar -xvzf clickhouse-client-${VERSION}-amd64.tgz --strip-components=1

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build /build/usr/bin/ /usr/bin/
COPY --from=build /build/usr/share/clickhouse /usr/share/clickhouse

RUN set -ex ; \
  addgroup -S -g 999 clickhouse ; \
  adduser -S -D -H -s /bin/false -u 999 -G clickhouse clickhouse

RUN set -ex ; \
  install -d -o clickhouse -g clickhouse -m 0750 \
    /etc/clickhouse-server \
    /etc/clickhouse-server/config.d \
    /etc/clickhouse-server/users.d \
    /etc/clickhouse-keeper \
    /etc/clickhouse-keeper/config.d \
    /etc/clickhouse-client \
    /etc/clickhouse-client/config.d ; \
  install -d -o clickhouse -g clickhouse -m 0755 /var/lib/clickhouse ; \
  install -d -o clickhouse -g clickhouse -m 0755 /var/log/clickhouse-server ; \
  install -d -o root -g root -m 0755 /docker-entrypoint-initdb.d

# Default configurations
COPY --from=build --chown=clickhouse:clickhouse --chmod=0644 \
  /build/etc/clickhouse-server/config.xml /etc/clickhouse-server/config.xml
COPY --from=build --chown=clickhouse:clickhouse --chmod=0644 \
  /build/etc/clickhouse-server/users.xml /etc/clickhouse-server/users.xml
COPY --from=build --chown=clickhouse:clickhouse --chmod=0644 \
  /build/etc/clickhouse-keeper/keeper_config.xml /etc/clickhouse-keeper/keeper_config.xml
COPY --from=build --chown=clickhouse:clickhouse --chmod=0644 \
  /build/etc/clickhouse-client/config.xml /etc/clickhouse-client/config.xml

# Configuration overrides
COPY --chown=clickhouse:clickhouse --chmod=0644 \
  config.docker.xml /etc/clickhouse-server/config.d/00-docker.xml
COPY --chown=clickhouse:clickhouse --chmod=0644 \
  client.docker.xml /etc/clickhouse-client/config.d/00-docker.xml

RUN apk --no-cache add glibc-locale-en

ENV LANG="en_US.utf8"

ENV CLICKHOUSE_CONFIG=/etc/clickhouse-server/config.xml
ENV CLICKHOUSE_WATCHDOG_ENABLE=0

EXPOSE 8123/tcp 9000/tcp 9004/tcp 9005/tcp 9009/tcp

VOLUME [ "/var/lib/clickhouse" ]

ENTRYPOINT [ "/usr/bin/clickhouse" ]

CMD [ "docker-init" ]
