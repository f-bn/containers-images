## General informations

Custom Traefik image built from sources. 

**This image is running by default with a non-root user**, this means that it can't use Docker socket bind-mount natively.

Built with Go 1.25 and NodeJS 24.

## Traefik configuration

This image doesn't come with a default Traefik configuration. You can bring your own configuration to the container using command flags or by passing the static configuration file using bind-mount:

```shell
# Configuration flags
$ docker run [options] ghcr.io/f-bn/traefik:3.5.0 --log.level=INFO --api [flags]

# Mounting static configuration
$ docker run [options] -v traefik.yaml:/etc/traefik/traefik.yaml:ro ghcr.io/f-bn/traefik:3.5.0