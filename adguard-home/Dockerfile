# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=0.107.48

RUN apk add --no-cache libcap-utils

WORKDIR /build

ADD https://github.com/AdguardTeam/AdGuardHome/releases/download/v${VERSION}/AdGuardHome_${TARGETOS}_${TARGETARCH}.tar.gz /build/

RUN set -ex ; \
  tar -xzf /build/AdGuardHome_${TARGETOS}_${TARGETARCH}.tar.gz --strip-components=2 ; \
  setcap 'cap_net_bind_service=+ep' /build/AdGuardHome

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chmod=755 /build/AdGuardHome /usr/bin/adguard-home

RUN set -ex ; \
  mkdir -p /etc/adguard-home /var/lib/adguard-home ; \
  chown nonroot:nonroot /var/lib/adguard-home /etc/adguard-home

EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 853/tcp \
	853/udp 3000/tcp 3000/udp 5443/tcp 5443/udp 6060/tcp

USER nonroot

VOLUME [ "/var/lib/adguard-home" ]

ENTRYPOINT [ "/usr/bin/adguard-home" ]

CMD [ "-c", "/etc/adguard-home/config.yaml", \
      "-w", "/var/lib/adguard-home" ]

LABEL \
  org.opencontainers.image.title="adguard-home" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/adguard-home" \
  org.opencontainers.image.description="Network-wide ads & trackers blocking DNS server" \
  org.opencontainers.image.licenses="GPL-3.0-or-later" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"