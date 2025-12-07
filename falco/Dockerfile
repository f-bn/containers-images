# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION="0.42.1"

RUN apk --no-cache add gpg gpg-agent gnupg-dirmngr

ADD https://download.falco.org/packages/bin/x86_64/falco-${VERSION}-x86_64.tar.gz /build/falco.tar.gz
ADD https://download.falco.org/packages/bin/x86_64/falco-${VERSION}-x86_64.tar.gz.asc /build/falco.tar.gz.asc

WORKDIR /build

RUN gpg --keyserver-options auto-key-retrieve \
  --verify falco.tar.gz.asc falco.tar.gz

RUN tar -xzf falco.tar.gz --strip-components=1

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=build --chown=0:0 --chmod=755 \
  /build/usr/bin/falco /usr/bin/falco
COPY --from=build --chown=0:0 \
  /build/usr/share/falco /usr/share/falco
COPY --from=build --chown=0:0 --chmod=644 \
  /build/etc/falco/falco.yaml /etc/falco/falco.yaml
COPY --from=build --chown=0:0 --chmod=644 \
  /build/etc/falco/falco_rules.local.yaml /etc/falco/falco_rules.yaml

RUN apk --no-cache add libstdc++

ENV HOST_ROOT=/host

EXPOSE 8765/tcp

WORKDIR /etc/falco

ENTRYPOINT [ "/usr/bin/falco" ]