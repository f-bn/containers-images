## General informations

Custom Valkey key/value store image with protection mode disabled by default (like in the official Redis and Valkey images).

## Valkey configuration

By default, this image is bundled with a default Valkey configuration located in `/etc/valkey`, however this configuration file is not used by default. You can bring your own configuration to the container following this example (e.g using Docker):

```shell
$ docker run [options] -v valkey.conf:/etc/valkey/valkey.conf:ro ghcr.io/f-bn/valkey:9.0.0 /etc/valkey/valkey.conf
```