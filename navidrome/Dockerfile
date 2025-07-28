# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS ffmpeg-build

ARG FFMPEG_VERSION=7.1

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
    --enable-encoder=libmp3lame,libopus,aac \
    --enable-decoder=flac,libopus,mp3float \
    --enable-parser=flac,mpegaudio \
    --enable-muxer=opus,adts,mp3 \
    --enable-demuxer=flac,mp3 \
    --enable-filter=aresample \
    --enable-protocol=file,pipe \
    --enable-shared \
    --enable-gpl \
    --enable-libmp3lame \
    --enable-libopus ; \
  make -j "$(nproc)" DESTDIR=./dist install

# --- Build stage ---
FROM cgr.dev/chainguard/wolfi-base:latest AS build

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=0.58.0

WORKDIR /build

ADD https://github.com/navidrome/navidrome/releases/download/v${VERSION}/navidrome_${VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz \
  /build/navidrome_${VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz
ADD https://github.com/navidrome/navidrome/releases/download/v${VERSION}/navidrome_checksums.txt \
  /build/navidrome_checksums.txt

RUN set -ex ; \
  grep "navidrome_${VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" navidrome_checksums.txt | sha256sum -c ; \
  tar -xzf /build/navidrome_${VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz

# --- Final stage ---
FROM cgr.dev/chainguard/wolfi-base:latest

COPY --from=ffmpeg-build /build/dist/ /
COPY --from=build --chown=0:0 --chmod=0755\
  /build/navidrome /usr/bin/navidrome

RUN set -ex ; \
  mkdir -p /etc/navidrome /var/lib/navidrome /media/music ; \
  chown nonroot:nonroot /var/lib/navidrome

RUN apk add --no-cache opus lame-libs

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