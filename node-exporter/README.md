## General informations

Custom Prometheus Node Exporter image built from sources.

Built with Go 1.24.

## Node Exporter configuration

This image works exactly as the official image, the Node Exporter configuration is done using flags:

```shell
$ docker run [options] -v '/:/host:ro,rslave' ghcr.io/f-bn/node-exporter:1.9.1 \
    --path.rootfs="/host" \
    --path.procfs="/host/proc" \
    --path.sysfs="/host/sys" [flags]
```