## General information

Custom Telegraf image built from source.

Built with Go 1.25.

### Image notes

This image contains a custom Telegraf build with a restricted set of plugins for my personal use.

The complete list of enabled plugins can be found [here](./build-plugins.conf).

## Telegraf configuration

This image comes with a basic [configuration](./telegraf.default.conf) that writes some metrics to stdout.

You can bring your own configuration to the container by mounting the custom configuration file into the container (e.g. using Docker):

```shell
$ docker run [options] -v telegraf.conf:/etc/telegraf/telegraf.conf ghcr.io/f-bn/telegraf:1.36.3 [flags]
```