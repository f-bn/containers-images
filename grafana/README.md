## General informations

Custom Grafana image built using official binary.

## Grafana configuration

This image come with a minimal Grafana configuration located in `/etc/grafana/grafana.ini`.

You can also bring your own configuration by mounting the custom configuration file into the container (e.g using Docker):

```shell
$ docker run [options] -v grafana.ini:/etc/grafana/grafana.ini:ro ghcr.io/f-bn/grafana:12.1.0
```