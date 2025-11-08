## General informations

Custom Alertmanager image built from sources.

Built with Go 1.25 and NodeJS 24.

## Alertmanager configuration

This image come with the [default Alertmanager configuration](https://github.com/prometheus/alertmanager/blob/main/examples/ha/alertmanager.yml) provided in the official Alertmanager GitHub repository. 

You can also bring your own configuration to the container using flags or by mounting the custom configuration file into the container (e.g using Docker):

```shell
# Configuration flags
$ docker run [options] ghcr.io/f-bn/alertmanager:0.28.1 [flags]

# Mounting static configuration
$ docker run [options] -v alertmanager.yml:/etc/alertmanager/alertmanager.yml:ro ghcr.io/f-bn/alertmanager:0.28.1
```