# --- Build stage ---
FROM docker.io/golang:1.25.5 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="2.32.0"

ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

ADD --keep-git-dir \
  https://github.com/falcosecurity/falcosidekick.git#${VERSION} /build

WORKDIR /build

RUN go mod download

RUN set -ex ; \
  mkdir -p dist ; \
  go build -trimpath -ldflags "-s -w \
      -X main.GitVersion=$(git describe --tags --always --dirty) \
      -X main.gitCommit=$(git rev-parse HEAD) \
      -X main.gitTreeState=clean \
      -X main.buildDate=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    -gcflags all=-trimpath=/src -asmflags all=-trimpath=/src \
    -a -installsuffix cgo \
    -o dist/falco-sidekick .

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
  /build/dist/falco-sidekick /usr/bin/falco-sidekick

RUN set -ex ; \
  addgroup -S -g 999 falco ; \
  adduser -S -D -H -s /bin/false -u 999 -G falco falco

RUN set -ex ; \
  mkdir -p /etc/falco ; \
  chown root:falco /etc/falco ; \
  chmod 750 /etc/falco

USER falco

EXPOSE 2801/tcp

WORKDIR /etc/falco

ENTRYPOINT [ "/usr/bin/falco-sidekick" ]