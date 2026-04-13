# --- Build stage ---
FROM docker.io/golang:1.26.2 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="7.15.1"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

WORKDIR /build

ADD --keep-git-dir \
  https://github.com/oauth2-proxy/oauth2-proxy.git#v${VERSION} /build

RUN set -ex ; \
  mkdir -p /build/dist ; \
  go build -ldflags="-s -w \
      -X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=${VERSION}" \
    -installsuffix cgo -o "./dist/oauth2-proxy" 

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/dist/oauth2-proxy /usr/bin/oauth2-proxy

RUN set -ex ; \
  addgroup -S -g 999 oauth2-proxy ; \
  adduser -S -D -H -s /bin/false -u 999 -G oauth2-proxy oauth2-proxy

RUN install -o root -g oauth2-proxy -m 0750 -d /etc/oauth2-proxy

USER oauth2-proxy

EXPOSE 4180/tcp

WORKDIR /etc/oauth2-proxy

ENTRYPOINT [ "/usr/bin/oauth2-proxy" ]
