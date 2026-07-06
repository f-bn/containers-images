# --- Build stage ---
FROM docker.io/golang:1.26.4 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="1.39.1"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

ADD --keep-git-dir \
  https://github.com/influxdata/telegraf.git#v${VERSION} /build

WORKDIR /build

COPY build-plugins.conf /build/build-plugins.conf

RUN set -ex ; \
  mkdir -p /build/dist ; \
  go build \
    -tags "custom,$(paste -sd, /build/build-plugins.conf)" \
    -ldflags "-s -w \
      -X github.com/influxdata/telegraf/internal.Commit=$(git rev-parse --short HEAD) \
      -X github.com/influxdata/telegraf/internal.Branch=v${VERSION} \
      -X github.com/influxdata/telegraf/internal.Version=${VERSION}" \
    -o "./dist/telegraf" ./cmd/telegraf

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/dist/telegraf /usr/bin/telegraf

RUN set -ex ; \
  addgroup -S -g 999 telegraf ; \
  adduser -S -D -H -s /bin/false -u 999 -G telegraf telegraf

RUN install -d -o root -g telegraf -m 0755 /etc/telegraf

RUN apk add --no-cache lm-sensors

COPY --chown=root:telegraf \
  telegraf.default.conf /etc/telegraf/telegraf.conf

USER telegraf

WORKDIR /etc/telegraf

ENTRYPOINT [ "/usr/bin/telegraf" ]