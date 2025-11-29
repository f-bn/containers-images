# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build-server

ARG VERSION="18.1"

ADD https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.gz /build/postgresql-${VERSION}.tar.gz
ADD https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.gz.sha256 /build/postgresql-${VERSION}.tar.gz.sha256

WORKDIR /build

RUN set -ex ; \
  cat postgresql-${VERSION}.tar.gz.sha256 | sha256sum -c ; \
  tar -xvzf postgresql-${VERSION}.tar.gz --strip-components=1

RUN --mount=type=cache,target=/etc/apk/cache \
  apk add \
    autoconf \
    automake \
    bison \
    build-base \
    clang-21 \
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
    --includedir=/usr/include/postgresql \
    --datarootdir=/usr/share/postgresql ; \
  make -j"$(nproc)" ; \
  make DESTDIR="$PWD/dist" install ; \
  make DESTDIR="$PWD/dist" -C contrib install

# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build-extensions

ARG PG_CRON_VERSION="1.6.7"
ARG PG_REPACK_VERSION="1.5.3"
ARG PG_PARTMAN_VERSION="5.3.1"
ARG PG_VECTOR_VERSION="0.8.1"

ADD https://github.com/citusdata/pg_cron.git#v${PG_CRON_VERSION} /build/pg_cron
ADD https://github.com/reorg/pg_repack.git#ver_${PG_REPACK_VERSION} /build/pg_repack
ADD https://github.com/pgpartman/pg_partman.git#v${PG_PARTMAN_VERSION} /build/pg_partman
ADD https://github.com/pgvector/pgvector.git#v${PG_VECTOR_VERSION} /build/pgvector

COPY --from=build-server /build/dist/usr/bin/               /usr/bin/
COPY --from=build-server /build/dist/usr/lib/postgresql     /usr/lib/postgresql
COPY --from=build-server /build/dist/usr/include/postgresql /usr/include/postgresql

RUN --mount=type=cache,target=/etc/apk/cache \
  apk add \
    build-base \
    clang-21 \
    cmake \
    lz4-dev \
    openssl-dev \
    zlib-dev \
    zstd-dev

WORKDIR /build/pg_cron
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

WORKDIR /build/pg_repack
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

WORKDIR /build/pg_partman
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

WORKDIR /build/pgvector
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build-pgbackrest

ARG PGBACKREST_VERSION="2.57.0"

ADD https://github.com/pgbackrest/pgbackrest.git#release/${PGBACKREST_VERSION} /build

COPY --from=build-server /build/dist/usr/bin/               /usr/bin/
COPY --from=build-server /build/dist/usr/lib/postgresql     /usr/lib/postgresql
COPY --from=build-server /build/dist/usr/include/postgresql /usr/include/postgresql

ENV PKG_CONFIG_PATH="/usr/lib/postgresql/pkgconfig" 

WORKDIR /build

RUN --mount=type=cache,target=/etc/apk/cache \
  apk add \
    build-base \
    bzip2-dev \
    libssh2-dev \
    libxml2-dev \
    lz4-dev \
    meson \
    ninja-build \
    openssl-dev \
    yaml-dev \
    zlib-dev \
    zstd-dev

RUN set -ex ; \
  meson setup "${PWD}/dist" "${PWD}" ; \
  ninja -C "${PWD}/dist"

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VERSION="18.1"

# Compatibility environment variables
ENV PG_MAJOR="${VERSION%%.*}" 
ENV PGDATA="/var/lib/postgresql/${PG_MAJOR}/data"

# Core server
COPY --from=build-server /build/dist/ /

# Extensions
COPY --from=build-extensions /build/pg_cron/dist/ /
COPY --from=build-extensions /build/pg_repack/dist/ /
COPY --from=build-extensions /build/pg_partman/dist/ /
COPY --from=build-extensions /build/pgvector/dist/ /

# pgBackRest
COPY --from=build-pgbackrest /build/dist/src/pgbackrest /usr/bin/pgbackrest

RUN set -ex ; \
  addgroup -S -g 999 postgres ; \
  adduser -S -D -s /bin/sh -h /var/lib/postgresql -u 999 -G postgres postgres

RUN set -ex ; \
  mkdir -p /etc/postgresql/config.d /var/lib/postgresql/backups ${PGDATA} ; \
  chown -R postgres:postgres /var/lib/postgresql ; \
  chmod -R 700 /var/lib/postgresql

COPY postgresql.default.conf /etc/postgresql/postgresql.conf

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