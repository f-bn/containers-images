## General informations

Custom Navidrome image with a minimal custom ffpmeg audio-only build.

### ffmpeg notes

This image contains a custom *ffmpeg* **audio-only** build with a restricted set of audio codecs available for audio transcoding (video plugins are not needed at all by Navidrome):

  - Native ffmpeg AAC codec (aac)
  - [LAME](https://lame.sourceforge.io/) MP3 codec (libmp3lame)
  - [Opus](https://opus-codec.org/) codec (libopus)

The main goal is to keep Navidrome image as minimal as possible since *ffmpeg* can require lot of dependencies when compiled with a large set of audio/video codecs (like in regular Linux distributions such as Debian/Ubuntu or Fedora).

## Navidrome configuration

This image doesn't come with a default Navidrome configuration. You can bring your own configuration to the container (e.g using Docker):

```shell
$ docker run [options] -v /path/to/navidrome.toml:/etc/navidrome/navidrome.toml ghcr.io/f-bn/navidrome:0.58.0
```

More informations about Navidrome configuration [here](https://www.navidrome.org/docs/usage/configuration-options/).