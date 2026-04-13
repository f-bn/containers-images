## General informations

Custom Plik image built from sources. 

Built with Go 1.26 and NodeJS 24.

## Plik configuration

This image comes with a basic [configuration](./plikd.default.cfg) for starting the service. You can bring your own configuration to the container by mounting the custom configuration file into the container (e.g. using Docker):

```shell
$ docker run [options] -v plikd.cfg:/etc/plik/plikd.cfg:ro ghcr.io/f-bn/plik:1.4.2 [flags]
```