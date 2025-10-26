## General information

Custom Docker Registry (from the [Distribution](https://github.com/distribution/distribution) project) image built from source.

Built with Go 1.25.

## Registry configuration

This image comes with a basic [configuration](./config.default.yml) for starting the service.

You can bring your own configuration to the container by mounting the custom configuration file into the container (e.g. using Docker):

```shell
$ docker run [options] -v config.yaml:/etc/registry/config.yaml ghcr.io/f-bn/registry:3.0.0 [flags]
```