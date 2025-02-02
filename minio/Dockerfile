# --- Build stage ---
FROM docker.io/golang:1.23 AS build-minio

ARG TARGETOS
ARG TARGETARCH
ARG MINIO_VERSION="RELEASE.2024-10-13T13-34-11Z"

WORKDIR /build

RUN git clone --single-branch --branch ${MINIO_VERSION} https://github.com/minio/minio.git /build
RUN make build

# --- Build stage ---
FROM docker.io/golang:1.23 AS build-mc

ARG TARGETOS
ARG TARGETARCH
ARG MC_VERSION="RELEASE.2024-10-08T09-37-26Z"

WORKDIR /build

RUN git clone --single-branch --branch ${MC_VERSION} https://github.com/minio/mc.git /build
RUN make build

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build-minio --chmod=755 /build/minio /usr/bin/minio
COPY --from=build-mc    --chmod=755 /build/mc    /usr/bin/mc

RUN set -ex ; \
  mkdir -p /var/lib/minio ; \
  chown nonroot:nonroot /var/lib/minio

USER nonroot

EXPOSE 9000/tcp

VOLUME [ "/var/lib/minio" ]

ENTRYPOINT [ "/usr/bin/minio" ]

CMD [ "server", "/var/lib/minio" ]

LABEL \
  org.opencontainers.image.title="minio" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/minio" \
  org.opencontainers.image.description="MinIO is a High Performance Object Storage, API compatible with Amazon S3 cloud storage service" \
  org.opencontainers.image.licenses="AGPL-3.0-only" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"