# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.24.1

RUN set -ex ; \
  apk add --no-cache \
    automake \
    autoconf \
    build-base \
    c-ares-dev \
    libevent-dev \
    libpq \
    openssl-dev

WORKDIR /build

ADD https://www.pgbouncer.org/downloads/files/${VERSION}/pgbouncer-${VERSION}.tar.gz /build/pgbouncer-${VERSION}.tar.gz
ADD https://www.pgbouncer.org/downloads/files/${VERSION}/pgbouncer-${VERSION}.tar.gz.sha256 /build/pgbouncer-${VERSION}.tar.gz.sha256

RUN set -ex ; \
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
  chown -R nonroot:nonroot /etc/pgbouncer /var/run/pgbouncer ; \
  chmod 750 /etc/pgbouncer ; \
  touch /etc/pgbouncer/userlist.txt ;

RUN apk add --no-cache c-ares libevent

USER nonroot

EXPOSE 6432/tcp

STOPSIGNAL SIGINT

ENTRYPOINT [ "/usr/bin/pgbouncer" ]

CMD [ "/etc/pgbouncer/pgbouncer.ini" ]