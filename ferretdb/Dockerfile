# --- Build stage ---
FROM docker.io/golang:1.22.2 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.23.0

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV GOAMD64=v1
ENV CGO_ENABLED=0

WORKDIR /build

RUN git clone --single-branch --branch v${VERSION} https://github.com/FerretDB/FerretDB.git /build
RUN set -ex ; \
    # https://pkg.go.dev/github.com/FerretDB/FerretDB/build/version
    echo "v${VERSION}" | tee ./build/version/version.txt ; \
    echo "$(git rev-parse HEAD)" | tee ./build/version/commit.txt ; \
    echo "docker" | tee ./build/version/package.txt ; \
    go build -v -o=./bin/ferretdb ./cmd/ferretdb

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chmod=755 /build/bin/ferretdb /usr/bin/ferretdb

RUN set -ex ; \
  mkdir -p /var/lib/ferretdb ; \
  chown nonroot:nonroot /var/lib/ferretdb

ENV FERRETDB_LISTEN_ADDR=:27017
ENV FERRETDB_DEBUG_ADDR=:8088
ENV FERRETDB_STATE_DIR=/var/lib/ferretdb
ENV FERRETDB_HANDLER=pg
ENV FERRETDB_SQLITE_URL="file:${FERRETDB_STATE_DIR}/"
ENV FERRETDB_LOG_LEVEL=info
ENV FERRETDB_TELEMETRY=off

USER nonroot

EXPOSE 27017/tcp 27018/tcp 8088/tcp

VOLUME [ "/var/lib/ferretdb" ]

ENTRYPOINT [ "/usr/bin/ferretdb" ]

LABEL \
  org.opencontainers.image.title="FerretDB" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/ferretdb" \
  org.opencontainers.image.description="A truly Open Source MongoDB alternative" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"