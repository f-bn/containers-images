## General informations

Custom Traefik image built from sources.

Built with Go 1.23 and NodeJS 22.

## Traefik configuration

This image doesn't come with a default Traefik configuration. You can bring your own configuration to the container using command flags or by passing the static configuration file using bind-mount:

```shell
# Configuration flags
$ docker run [options] ghcr.io/f-bn/traefik:3.3.3 --log.level=INFO --api [flags]

# Mounting static configuration
$ docker run [options] -v traefik.yaml:/etc/traefik/traefik.yaml:ro ghcr.io/f-bn/traefik:3.3.3
```