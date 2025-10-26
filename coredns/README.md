## General informations

Custom CoreDNS image built from sources.

Built with Go 1.25.

## CoreDNS configuration

This image doesn't come with a default CoreDNS configuration. You can bring your own configuration to the container (e.g using Docker):

```shell
$ docker run [options] \
    -v Corefile:/etc/coredns/Corefile:ro \
    -v /path/to/zonefiles:/etc/coredns/zones:ro \
    ghcr.io/f-bn/coredns:1.13.1 -conf /etc/coredns/Corefile
```

More informations about CoreDNS configuration [here](https://coredns.io/manual/configuration/).