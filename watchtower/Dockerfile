# --- Build stage ---
FROM docker.io/golang:1.20 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=1.7.1

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV GO111MODULE=on
ENV CGO_ENABLED=0

WORKDIR /build

RUN git clone --single-branch --branch v${VERSION} https://github.com/containrrr/watchtower.git /build
RUN set -ex ; \
  go build -a -ldflags "-extldflags '-static' -X github.com/containrrr/watchtower/internal/meta.Version=$(git describe --tags)" -o /build/bin/watchtower ; \
  go test ./... -v

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chmod=755 /build/bin/watchtower /usr/bin/watchtower

EXPOSE 8080/tcp

HEALTHCHECK CMD [ "/usr/bin/watchtower", "--health-check"]

ENTRYPOINT [ "/usr/bin/watchtower" ]

LABEL \
  org.opencontainers.image.title="watchtower" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/watchtower" \
  org.opencontainers.image.description="A process for automating Docker container base image updates" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"