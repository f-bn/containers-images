# --- Build stage ---
FROM docker.io/gcc:13.2 AS ffmpeg-build

ARG FFMPEG_VERSION=6.1.1

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends \
    libmp3lame-dev \
    libopus-dev \
    yasm \
    cmake \
    automake \
    build-essential

WORKDIR /build

ADD https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz /build/

RUN tar -xf ffmpeg-${FFMPEG_VERSION}.tar.xz --strip-components=1

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
  make -j2 DESTDIR=./dist install

# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=0.51.1

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