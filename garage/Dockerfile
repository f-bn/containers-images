# --- Build stage ---
FROM docker.io/rust:1.87.0 AS build

ARG VERSION="1.2.0"

WORKDIR /build

ADD https://git.deuxfleurs.fr/Deuxfleurs/garage.git#v${VERSION} /build/

RUN cargo build \
  --release \
  --no-default-features \
  --features "bundled-libs,metrics,sqlite,lmdb"

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/target/release/garage /usr/bin/garage
COPY --chown=0:65532 --chmod=640 \
  garage.default.toml /etc/garage.toml

RUN set -ex ; \
  mkdir -p /var/lib/garage ; \
  chown -R nonroot:nonroot /var/lib/garage ; \
  chmod -R 755 /var/lib/garage

ENV RUST_LOG="garage=info"
  
USER nonroot

EXPOSE 3900/tcp 3901/tcp

VOLUME [ "/var/lib/garage" ]

ENTRYPOINT [ "/usr/bin/garage" ]

CMD [ "server" ]

LABEL \
  org.opencontainers.image.title="garage" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/garage" \
  org.opencontainers.image.description="S3-compatible object store for small self-hosted geo-distributed deployments" \
  org.opencontainers.image.licenses="AGPL-3.0-or-later" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"