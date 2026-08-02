# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="9.1.1"

RUN apk add --no-cache automake autoconf build-base openssl-dev systemd-dev

WORKDIR /build

ADD https://github.com/valkey-io/valkey.git#${VERSION} /build

# Disable protected mode by default
# https://github.com/valkey-io/valkey-container/blob/mainline/9.1/debian/Dockerfile#L37
RUN sed -ri 's!^( *createBoolConfig[(]"protected-mode",.*, *)1( *,.*[)],)$!\10\2!' src/config.c

RUN set -ex ; \
  make BUILD_TLS=yes USE_SYSTEMD=yes -j "$(nproc)" all ; \
  make INSTALL_BIN=/build/dist install ; \
  strip /build/dist/valkey-*

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

RUN set -ex ; \
  addgroup -S -g 999 valkey ; \
  adduser -S -D -H -s /bin/false -u 999 -G valkey valkey

RUN set -ex ; \
  install -d -o root -g valkey -m 0750 /etc/valkey ; \
  install -d -o valkey -g valkey -m 0700 /var/lib/valkey

COPY --from=build /build/dist/ /usr/bin/
COPY --from=build /build/valkey.conf /etc/valkey/valkey.conf
COPY --from=build /build/sentinel.conf /etc/valkey/sentinel.conf

RUN apk add --no-cache libsystemd

USER valkey

EXPOSE 6379/tcp

VOLUME [ "/var/lib/valkey" ]

ENTRYPOINT [ "/usr/bin/valkey-server" ]