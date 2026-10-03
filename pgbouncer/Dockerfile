# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="1.26.0"

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
  make -j "$(nproc)" pgbouncer

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chmod=755 /build/pgbouncer /usr/bin/pgbouncer

RUN set -ex ; \
  addgroup -S -g 999 pgbouncer ; \
  adduser -S -D -H -s /bin/false -u 999 -G pgbouncer pgbouncer

RUN set -ex ; \
  install -d -o pgbouncer -g pgbouncer -m 0750 /etc/pgbouncer ; \
  install -o pgbouncer -g pgbouncer -m 0640 /dev/null /etc/pgbouncer/userlist.txt

COPY --chown=pgbouncer:pgbouncer --chmod=640 \
  pgbouncer.default.ini /etc/pgbouncer/pgbouncer.ini

RUN apk add --no-cache c-ares libevent openssl

USER pgbouncer

EXPOSE 6432/tcp

STOPSIGNAL SIGINT

ENTRYPOINT [ "/usr/bin/pgbouncer" ]

CMD [ "/etc/pgbouncer/pgbouncer.ini" ]