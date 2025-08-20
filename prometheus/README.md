## General informations

Custom Prometheus image built from sources. 

This image build process is different than official image version:

  - **Reduced set of service discovery plugins** (DNS, Kubernetes and Docker, HTTP and file are natively included)
  - **Trimmed debugging symbols** to reduce binary size

Built with Go 1.24 and NodeJS 24.

## Prometheus configuration

This image come with the [default Prometheus configuration](https://github.com/prometheus/prometheus/blob/main/documentation/examples/prometheus.yml) present in the official Prometheus GitHub repository. 

You can also bring your own configuration to the container using flags or by mounting the custom configuration file into the container (e.g using Docker):

```shell
# Configuration flags
$ docker run [options] ghcr.io/f-bn/prometheus:3.5.0 [flags]

# Mounting static configuration
$ docker run [options] -v prometheus.yml:/etc/prometheus/prometheus.yml:ro ghcr.io/f-bn/prometheus:3.5.0
```