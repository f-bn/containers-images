## General informations

Custom Blocky image built from sources.

Built with Go 1.23.

## Blocky configuration

This image doesn't come with a default Blocky configuration. You can bring your own configuration to the container (e.g using Docker):

```shell
# '/etc/blocky/config.yml' is the default configuration path
$ docker run [options] \
    -v config.yml:/etc/blocky/config.yml:ro \
    ghcr.io/f-bn/blocky:0.24
```

More informations about Blocky configuration [here](https://0xerr0r.github.io/blocky/latest/configuration/).