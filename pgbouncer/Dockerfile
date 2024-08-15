# --- Build stage ---
FROM docker.io/gcc:13.2 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.23.1

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends \
    ca-certificates \
    wget \
    libc6-dev \
    libevent-dev \
    libssl-dev \
    libc-ares-dev \
    libpq-dev \
    pkg-config

WORKDIR /build

RUN set -ex ; \
  wget -O pgbouncer-${VERSION}.tar.gz https://www.pgbouncer.org/downloads/files/${VERSION}/pgbouncer-${VERSION}.tar.gz ; \
  wget -O pgbouncer-${VERSION}.tar.gz.sha256 https://www.pgbouncer.org/downloads/files/${VERSION}/pgbouncer-${VERSION}.tar.gz.sha256 ; \
  cat pgbouncer-${VERSION}.tar.gz.sha256 | sha256sum -c ; \
  tar -xzf pgbouncer-${VERSION}.tar.gz --strip-components=1

RUN set -ex ; \
  ./configure --prefix=/usr ; \
  make -j "$(nproc)"

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chmod=755 /build/pgbouncer /usr/bin/pgbouncer
COPY --chown=nonroot:nonroot --chmod=640 pgbouncer.default.ini /etc/pgbouncer/pgbouncer.ini

RUN set -ex ; \
  mkdir -p /etc/pgbouncer /var/run/pgbouncer ; \
  touch /etc/pgbouncer/userlist.txt ; \
  chown -R nonroot:nonroot /etc/pgbouncer /var/run/pgbouncer ;

RUN apk add --no-cache c-ares libevent

USER nonroot

EXPOSE 6432/tcp

STOPSIGNAL SIGINT

ENTRYPOINT [ "/usr/bin/pgbouncer" ]

CMD [ "/etc/pgbouncer/pgbouncer.ini" ]

LABEL \
  org.opencontainers.image.title="pgbouncer" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/pgbouncer" \
  org.opencontainers.image.description="Lightweight connection pooler for PostgreSQL" \
  org.opencontainers.image.licenses="ISC" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"