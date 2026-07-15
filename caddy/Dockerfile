# --- Build stage ---
FROM docker.io/golang:1.26.5 AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="2.11.4"

ENV CADDY_VERSION="v${VERSION}"

WORKDIR /build

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build \
  --with github.com/caddy-dns/infomaniak \
  --output "${PWD}/caddy"

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=0755 \
    /build/caddy /usr/bin/caddy

RUN set -ex ; \
  addgroup -S -g 999 caddy ; \
  adduser -S -D -H -s /bin/false -u 999 -G caddy caddy

RUN set -ex ; \
  install -d -o caddy -g caddy -m 0750 /etc/caddy ; \
  install -d -o caddy -g caddy -m 0750 /var/lib/caddy

COPY --chown=caddy:caddy \
  Caddyfile.default /etc/caddy/Caddyfile

ENV XDG_CONFIG_HOME=/etc
ENV XDG_DATA_HOME=/var/lib

USER caddy

EXPOSE 80/tcp 443/tcp 443/udp 2019/tcp

WORKDIR /etc/caddy

ENTRYPOINT [ "/usr/bin/caddy" ]

CMD [ "run", "--config", "/etc/caddy/Caddyfile" ]