# --- Build stage ---
FROM docker.io/golang:1.24.6 AS build

ARG VERSION="0.53.0"

WORKDIR /build

ADD --keep-git-dir \
  https://github.com/google/cadvisor.git#v${VERSION} /build/

RUN make build

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/_output/cadvisor /usr/bin/cadvisor

EXPOSE 8080/tcp

ENTRYPOINT [ "/usr/bin/cadvisor" ]

LABEL \
  org.opencontainers.image.title="cadvisor" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/cadvisor" \
  org.opencontainers.image.description="Analyzes resource usage and performance characteristics of running containers" \
  org.opencontainers.image.licenses="Apache-2.0" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"