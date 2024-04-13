## General informations

Custom AdGuard Home image from official binary.

## AdGuard Home configuration

This image doesn't come with a default AdGuard Home configuration. You can bring your own configuration to the container (e.g using Docker):

```shell
# Since AdGuard is generating configuration during startup, configuration volume must be mounted R/W
$ docker run [options] -v /path/to/configdir:/etc/adguard-home:rw ghcr.io/f-bn/adguard-home:0.107.48
```

More informations about AdGuard Home configuration [here](https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration).