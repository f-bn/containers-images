## General informations

Custom Navidrome image with a minimal ffpmeg audio-only build.

### ffmpeg notes

This image contains a custom ffmpeg **audio-only** build with a limited audio plugins available (video plugins are not needed at all by Navidrome).

There was two goals to build ffmpeg from sources for Navidrome:
  - Keep Navidrome image as minimal as possible since ffmpeg can require a lot of dependencies when compiled with a large set of audio/video plugins (like in standard Linux distributions repositories). 
  - Support for [Opus audio codec](https://opus-codec.org/) for audio transcoding (since native WolfiOS ffmpeg package is not built with Opus support)

## Navidrome configuration

This image doesn't come with a default Navidrome configuration. You can bring your own configuration to the container (e.g using Docker):

```shell
$ docker run [options] -v navidrome.toml:/etc/navidrome/config.toml \
    ghcr.io/f-bn/navidrome:0.51.0 --configfile /etc/navidrome/config.toml
```

More informations about Navidrome configuration [here](https://www.navidrome.org/docs/usage/configuration-options/).