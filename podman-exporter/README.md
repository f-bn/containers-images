## General informations

Custom Prometheus [Podman Exporter](https://github.com/containers/prometheus-podman-exporter) image built from sources.

Built with Go 1.25.

## Podman Exporter configuration

This image works exactly as the official image, the Podman Exporter configuration is done using flags:

```shell
$ podman run [options] --name podman-exporter \
    -v /run/podman/podman.sock:/run/podman/podman.sock \
    -e CONTAINER_HOST="unix:///run/podman/podman.sock" \
    --security-opt label=disable \
  ghcr.io/f-bn/podman-exporter:1.19.0
```