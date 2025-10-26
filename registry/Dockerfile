# --- Build stage ---
FROM docker.io/golang:1.25.2 AS build-binary

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="3.0.0"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV GO111MODULE=auto
ENV CGO_ENABLED=0

ADD --keep-git-dir \
  https://github.com/distribution/distribution.git#v${VERSION} /build  

WORKDIR /build

RUN set -ex ; \
  mkdir -p /build/bin ; \
  go build -trimpath -ldflags "-s -w -extldflags '-Wl,-z,now' \
      -X github.com/distribution/distribution/v3/version.version=${VERSION} \
      -X github.com/distribution/distribution/v3/version.revision=$(git rev-parse HEAD) \
      -X github.com/distribution/distribution/v3/version.mainpkg=github.com/distribution/distribution/v3" \
    -o /build/bin/registry ./cmd/registry

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VERSION="3.0.0"

COPY --from=build-binary --chown=0:0 --chmod=0755 \
  /build/bin/registry /usr/bin/registry

RUN set -ex ; \
  addgroup -S -g 999 registry ; \
  adduser -S -D -H -s /bin/false -u 999 -G registry registry

RUN set -ex ; \
  mkdir -p /etc/registry /var/lib/registry ; \
  chown root:registry /etc/registry ; \
  chmod 750 /etc/registry ; \
  chown registry:registry /var/lib/registry ; \
  chmod 700 /var/lib/registry

COPY config.default.yml /etc/registry/config.yml

ENV OTEL_TRACES_EXPORTER=none

USER registry

EXPOSE 5000/tcp

WORKDIR /etc/registry

ENTRYPOINT [ "/usr/bin/registry" ]

CMD [ "serve", "/etc/registry/config.yml" ]

LABEL \
  org.opencontainers.image.title="registry" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/registry" \
  org.opencontainers.image.description="Distribution implementation for storing and distributing of container images and artifacts" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.fr>"