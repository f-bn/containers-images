# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS pg-build

ARG TARGETOS
ARG TARGETARCH
ARG PG_VERSION="15.8"

RUN set -ex ; \
  apk add --no-cache \
    automake \
    autoconf \
    build-base \
    clang-18-dev \
    execline-dev \
    icu-dev \
    libedit-dev \
    libxml2-dev \
    llvm-18-dev \
    lz4-dev \
    openldap-dev \
    openssl-dev \
    zlib-dev \
    zstd-dev

WORKDIR /build

ADD https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz /build/postgresql-${PG_VERSION}.tar.gz
ADD https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz.sha256 /build/postgresql-${PG_VERSION}.tar.gz.sha256

RUN set -ex ; \
  cat postgresql-${PG_VERSION}.tar.gz.sha256 | sha256sum -c ; \
  tar -xvzf postgresql-${PG_VERSION}.tar.gz --strip-components=1

RUN set -ex ; \
  ./configure \
    --with-llvm \
    --with-lz4 \
    --with-zstd \
    --with-ssl=openssl \
    --with-ldap \
    --with-uuid=e2fs \
    --with-libxml \
    --prefix=/usr \
    --with-libedit-preferred \
    --bindir=/usr/bin \
    --libdir=/usr/lib/postgresql \
    --includedir=/usr/include/postgresql \
    --datarootdir=/usr/share/postgresql ; \
  make -j"$(nproc)" ; \
  make DESTDIR="$PWD/dist" install ; \
  make DESTDIR="$PWD/dist" -C contrib install

# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS pg-ext-build

ARG TARGETOS
ARG TARGETARCH

ARG PG_CRON_VERSION="1.6.4"
ARG PG_REPACK_VERSION="1.5.0"
ARG PG_PARTMAN_VERSION="5.1.0"
ARG PG_AUDIT_VERSION="1.7.0"

COPY --from=pg-build /build/dist/usr/bin/               /usr/bin/
COPY --from=pg-build /build/dist/usr/lib/postgresql     /usr/lib/postgresql
COPY --from=pg-build /build/dist/usr/include/postgresql /usr/include/postgresql
COPY --from=pg-build /build/dist/usr/share/postgresql   /usr/share/postgresql

RUN set -ex ; \
  apk add --no-cache \
    automake \
    autoconf \
    build-base \
    clang-18-dev \
    lz4-dev \
    openldap-dev \
    openssl-dev \
    zlib-dev \
    zstd-dev

WORKDIR /build/pg_cron
ADD https://github.com/citusdata/pg_cron.git#v${PG_CRON_VERSION} /build/pg_cron
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

WORKDIR /build/pg_repack
ADD https://github.com/reorg/pg_repack.git#ver_${PG_REPACK_VERSION} /build/pg_repack
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

WORKDIR /build/pg_partman
ADD https://github.com/pgpartman/pg_partman.git#v${PG_PARTMAN_VERSION} /build/pg_partman
RUN set -ex ; \
  make -j"$(nproc)" ; \
  make DESTDIR="${PWD}/dist" install

WORKDIR /build/pg_audit
ADD https://github.com/pgaudit/pgaudit.git#${PG_AUDIT_VERSION} /build/pg_audit
RUN set -ex ; \
  make USE_PGXS=1 DESTDIR="${PWD}/dist" install

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

# Core server
COPY --from=pg-build /build/dist/ /

# Extensions
COPY --from=pg-ext-build /build/pg_cron/dist/ /
COPY --from=pg-ext-build /build/pg_repack/dist/ /
COPY --from=pg-ext-build /build/pg_partman/dist/ /
COPY --from=pg-ext-build /build/pg_audit/dist/ /

RUN set -ex ; \
  addgroup -S -g 65535 postgres ; \
  adduser -S -D -H -u 65535 -G postgres -h /var/lib/postgresql -s /bin/sh postgres

RUN set -ex ; \
  mkdir -p /etc/postgresql /etc/postgresql/config.d /var/lib/postgresql/15/data ; \
  chown postgres:postgres /var/lib/postgresql

RUN set -ex ; \
  apk add --no-cache \
    glibc-locale-en \
    gosu \
    icu-libs \
    libedit \
    libldap \
    libxml2 \
    libzstd1 \
    liblz4-1 \
    posix-libc-utils \
    postgresql-15-oci-entrypoint

COPY postgresql.default.conf /etc/postgresql/postgresql.conf

ENV PGDATA=/var/lib/postgresql/15/data
ENV LANG=en_US.utf8

EXPOSE 5432/tcp

STOPSIGNAL SIGINT

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"  ]

LABEL \
  org.opencontainers.image.title="postgresql" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/postgresql" \
  org.opencontainers.image.description="Custom PostgreSQL 15 image with additional extensions, configuration and tools embedded" \
  org.opencontainers.image.licenses="PostgreSQL" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"