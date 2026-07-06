# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS base-common

RUN --mount=type=cache,target=/etc/apk/cache \
  apk add \
    bash \
    autoconf \
    automake \
    bison \
    build-base \
    clang-21 \
    cmake \
    execline-dev \
    flex \
    icu-dev \
    libedit-dev \
    libuuid \
    lld-21-dev \
    llvm-21-dev \
    lz4-dev \
    openssl-dev \
    systemd-dev \
    util-linux-dev \
    zlib-dev \
    zstd-dev

# --- Build stage ---
FROM base-common AS build-server

ARG VERSION="18.4"

ADD https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.gz /build/postgresql-${VERSION}.tar.gz
ADD https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.gz.sha256 /build/postgresql-${VERSION}.tar.gz.sha256

WORKDIR /build

RUN set -ex ; \
  cat postgresql-${VERSION}.tar.gz.sha256 | sha256sum -c ; \
  tar -xvzf postgresql-${VERSION}.tar.gz --strip-components=1

RUN set -ex ; \
  ./configure \
    --with-llvm \
    --with-lz4 \
    --with-zstd \
    --with-ssl=openssl \
    --with-uuid=e2fs \
    --with-systemd \
    --prefix=/usr \
    --bindir=/usr/bin \
    --libdir=/usr/lib/postgresql \
    --sysconfdir=/etc \
    --includedir=/usr/include/postgresql \
    --datarootdir=/usr/share/postgresql ; \
  make -j"$(nproc)" ; \
  make DESTDIR="$PWD/dist" install ; \
  make DESTDIR="$PWD/dist" -C contrib install

# --- Build stage ---
FROM base-common AS base-extensions

COPY --from=build-server /build/dist/usr/bin/pg_config      /usr/bin/pg_config
COPY --from=build-server /build/dist/usr/lib/postgresql     /usr/lib/postgresql
COPY --from=build-server /build/dist/usr/include/postgresql /usr/include/postgresql

ENV PKG_CONFIG_PATH="/usr/lib/postgresql/pkgconfig"

# --- Build stage ---
FROM base-extensions AS build-pgcron

ARG PG_CRON_VERSION="1.6.7"

ADD https://github.com/citusdata/pg_cron.git#v${PG_CRON_VERSION} /build

WORKDIR /build
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

# --- Build stage ---
FROM base-extensions AS build-pgrepack

ARG PG_REPACK_VERSION="1.5.3"

ADD https://github.com/reorg/pg_repack.git#ver_${PG_REPACK_VERSION} /build

WORKDIR /build
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

# --- Build stage ---
FROM base-extensions AS build-pgsqueeze

ARG PG_SQUEEZE_VERSION="1.9.3"

ADD https://github.com/cybertec-postgresql/pg_squeeze.git#REL${PG_SQUEEZE_VERSION//./_} /build

WORKDIR /build
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

# --- Build stage ---
FROM base-extensions AS build-pgpartman

ARG PG_PARTMAN_VERSION="5.4.3"

ADD https://github.com/pgpartman/pg_partman.git#v${PG_PARTMAN_VERSION} /build

WORKDIR /build
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

# --- Build stage ---
FROM base-extensions AS build-pgvector

ARG PG_VECTOR_VERSION="0.8.2"

ADD https://github.com/pgvector/pgvector.git#v${PG_VECTOR_VERSION} /build

WORKDIR /build
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

# --- Build stage ---
FROM base-extensions AS build-pgstatmonitor

ARG PG_STAT_MONITOR_VERSION="2.3.2"

ADD https://github.com/percona/pg_stat_monitor.git#${PG_STAT_MONITOR_VERSION} /build

WORKDIR /build
RUN set -ex ; \
  make USE_PGXS=1 -j"$(nproc)" ; \
  make USE_PGXS=1 DESTDIR="${PWD}/dist" install

# --- Build stage ---
FROM base-extensions AS build-timescaledb

ARG TIMESCALEDB_VERSION="2.28.1"

ADD https://github.com/timescale/timescaledb.git#${TIMESCALEDB_VERSION} /build

WORKDIR /build
RUN BUILD_DIR="/build/tsbuild" ./bootstrap

WORKDIR /build/tsbuild
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="/build/dist" install

# --- Build stage ---
FROM base-extensions AS build-pgbackrest

ARG PGBACKREST_VERSION="2.58.0"

ADD https://github.com/pgbackrest/pgbackrest.git#release/${PGBACKREST_VERSION} /build

RUN --mount=type=cache,target=/etc/apk/cache \
  apk add \
    bzip2-dev \
    libssh2-dev \
    libxml2-dev \
    ninja \
    meson \
    yaml-dev

WORKDIR /build
RUN set -ex ; \
  meson setup "${PWD}/dist" "${PWD}" ; \
  ninja -C "${PWD}/dist"

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VERSION="18.4"

# Compatibility environment variables
ENV PG_MAJOR="${VERSION%%.*}"
ENV PGDATA="/var/lib/postgresql/${PG_MAJOR}/data"

# Core server
COPY --from=build-server /build/dist/ /

# Extensions
COPY --from=build-pgcron    /build/dist/ /
COPY --from=build-pgrepack  /build/dist/ /
COPY --from=build-pgsqueeze /build/dist/ /
COPY --from=build-pgpartman /build/dist/ /
COPY --from=build-pgvector  /build/dist/ /
COPY --from=build-pgstatmonitor /build/dist/ /
COPY --from=build-timescaledb /build/dist/ /

# Additional tools
COPY --from=build-pgbackrest /build/dist/src/pgbackrest /usr/bin/pgbackrest

RUN set -ex ; \
  addgroup -S -g 999 postgres ; \
  adduser -S -D -s /bin/sh -h /var/lib/postgresql -u 999 -G postgres postgres

RUN set -ex ; \
  install -d -o postgres -g postgres -m 0755 /etc/postgresql/config.d ; \
  install -d -o postgres -g postgres -m 0700 ${PGDATA} /var/lib/postgresql/backups

COPY --chown=postgres:postgres \
  postgresql.default.conf /etc/postgresql/postgresql.conf

RUN --mount=type=cache,target=/etc/apk/cache \
  apk add \
    glibc-locale-en \
    gosu \
    icu \
    libedit \
    liblz4-1 \
    libbz2-1 \
    libssh2 \
    libsystemd \
    libxml2-16 \
    libzstd1 \
    posix-libc-utils \
    postgresql-${PG_MAJOR}-oci-entrypoint

ENV LANG="en_US.utf8"
ENV POSTGRES_INITDB_ARGS="--no-instructions --data-checksums"

EXPOSE 5432/tcp

STOPSIGNAL SIGINT

VOLUME [ "/var/lib/postgresql" ]

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "postgres", "-c", "config_file=/etc/postgresql/postgresql.conf" ]