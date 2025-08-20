## General informations

Custom Prometheus image built from sources.

Built with Go 1.24 and NodeJS 24.

### Image notes

This image contains a custom Prometheus build that is different than official [prom/prometheus](https://hub.docker.com/r/prom/prometheus) image:

  - **Reduced set of service discovery plugins** (only DNS, Kubernetes and Docker)
  - **Trimmed debugging symbols** to reduce binary size

> [!NOTE]
> Native `HTTP` and `File` service discovery plugins are still included by default

## Prometheus configuration

This image come with the [default Prometheus configuration](https://github.com/prometheus/prometheus/blob/main/documentation/examples/prometheus.yml) present in the official Prometheus GitHub repository. 

You can also bring your own configuration to the container using flags or by mounting the custom configuration file into the container (e.g using Docker):

```shell
# Configuration flags
$ docker run [options] ghcr.io/f-bn/prometheus:3.5.0 [flags]

# Mounting static configuration
$ docker run [options] -v prometheus.yml:/etc/prometheus/prometheus.yml:ro ghcr.io/f-bn/prometheus:3.5.0
```