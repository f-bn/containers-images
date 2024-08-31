# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS ffmpeg-build

ARG FFMPEG_VERSION=7.0.2

RUN set -ex ; \
  apk add --no-cache \
    autoconf \
    automake \
    build-base \
    lame-dev \
    libogg-dev \
    opus-dev \
    yasm-dev

WORKDIR /build

ADD https://git.ffmpeg.org/ffmpeg.git#n${FFMPEG_VERSION} /build/

RUN set -ex ; \
  ./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-doc \
    --disable-network \
    --disable-autodetect \
    --disable-everything \
    --enable-encoder=libopus,aac \
    --enable-decoder=flac,libopus \
    --enable-parser=flac \
    --enable-muxer=flac,opus,adts \
    --enable-demuxer=flac \
    --enable-filter=aresample \
    --enable-protocol=file,pipe \
    --enable-shared \
    --enable-gpl \
    --enable-libopus ; \
  make -j "$(nproc)" DESTDIR=./dist install

# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=0.52.0

WORKDIR /build

ADD https://github.com/navidrome/navidrome/releases/download/v${VERSION}/navidrome_${VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz /build/

RUN tar -xzf /build/navidrome_${VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

ARG TARGETOS
ARG TARGETARCH

COPY --from=ffmpeg-build /build/dist/ /
COPY --from=build /build/navidrome /usr/bin/navidrome

RUN set -ex ; \
  mkdir -p /etc/navidrome /var/lib/navidrome /media/music ; \
  chown nonroot:nonroot /var/lib/navidrome

RUN apk add --no-cache opus

ENV ND_MUSICFOLDER=/media/music
ENV ND_DATAFOLDER=/var/lib/navidrome
ENV ND_CACHEFOLDER=${ND_DATAFOLDER}/cache

USER nonroot

EXPOSE 4533/tcp

VOLUME [ "/var/lib/navidrome" ]

ENTRYPOINT [ "/usr/bin/navidrome" ]

LABEL \
  org.opencontainers.image.title="navidrome" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/navidrome" \
  org.opencontainers.image.description="Modern Music Server and Streamer compatible with Subsonic/Airsonic" \
  org.opencontainers.image.licenses="GPL-3.0-or-later" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"