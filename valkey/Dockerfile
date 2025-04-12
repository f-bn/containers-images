# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="8.1.0"

RUN set -ex ; \
  apk add --no-cache \
    automake \
    autoconf \
    build-base \
    git \
    openssl-dev

WORKDIR /build

ADD https://github.com/valkey-io/valkey.git#${VERSION} /build

COPY patches/0000-disable-protected-mode.patch /build/0000-disable-protected-mode.patch

RUN set -ex ; \
  # Disable protected mode by default
  # https://github.com/valkey-io/valkey-container/blob/mainline/7.2/alpine/Dockerfile#L80
  git apply 0000-disable-protected-mode.patch ; \
  # Build
  make BUILD_TLS=yes -j "$(nproc)" all ; \
  make INSTALL_BIN=/build/dist install ; \
  strip /build/dist/valkey-*

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

RUN set -ex ; \
  mkdir -p /etc/valkey /var/lib/valkey ; \
  chown nonroot:nonroot /var/lib/valkey

COPY --from=build /build/dist/ /usr/bin/
COPY --from=build /build/valkey.conf /etc/valkey/valkey.conf
COPY --from=build /build/sentinel.conf /etc/valkey/sentinel.conf

RUN apk add --no-cache posix-libc-utils 

USER nonroot

EXPOSE 6379/tcp

VOLUME [ "/var/lib/valkey" ]

WORKDIR /var/lib/valkey

ENTRYPOINT [ "/usr/bin/valkey-server" ]

LABEL \
  org.opencontainers.image.title="valkey" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/valkey" \
  org.opencontainers.image.description="An open source, in-memory data store" \
  org.opencontainers.image.licenses="BSD-3-Clause" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"