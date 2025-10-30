# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="9.0.0"

RUN set -ex ; \
  apk add --no-cache \
    automake \
    autoconf \
    build-base \
    git \
    openssl-dev

WORKDIR /build

ADD https://github.com/valkey-io/valkey.git#${VERSION} /build

RUN set -ex ; \
  # Disable protected mode by default
  # https://github.com/valkey-io/valkey-container/blob/mainline/7.2/alpine/Dockerfile#L80
  sed -ri 's!^( *createBoolConfig[(]"protected-mode",.*, *)1( *,.*[)],)$!\10\2!' src/config.c ; \
  # Build
  make BUILD_TLS=yes -j "$(nproc)" all ; \
  make INSTALL_BIN=/build/dist install ; \
  strip /build/dist/valkey-*

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VERSION="9.0.0"

RUN set -ex ; \
  addgroup -S -g 999 valkey ; \
  adduser -S -D -H -s /bin/false -u 999 -G valkey valkey

RUN set -ex ; \
  mkdir -p /etc/valkey /var/lib/valkey ; \
  chown root:valkey /etc/valkey ; \
  chmod 750 /etc/valkey ; \
  chown valkey:valkey /var/lib/valkey ; \
  chmod 700 /var/lib/valkey

COPY --from=build /build/dist/ /usr/bin/
COPY --from=build /build/valkey.conf /etc/valkey/valkey.conf
COPY --from=build /build/sentinel.conf /etc/valkey/sentinel.conf

RUN apk add --no-cache posix-libc-utils 

USER valkey

EXPOSE 6379/tcp

VOLUME [ "/var/lib/valkey" ]

WORKDIR /var/lib/valkey

ENTRYPOINT [ "/usr/bin/valkey-server" ]

LABEL \
  org.opencontainers.image.title="valkey" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/valkey" \
  org.opencontainers.image.description="An open source, in-memory data store" \
  org.opencontainers.image.licenses="BSD-3-Clause" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.fr>"