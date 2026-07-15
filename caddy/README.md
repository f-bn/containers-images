## General informations

Custom Caddy image built from sources using `xcaddy`.

Built with Go 1.26.

### Image notes

This image embeds the following plugins:

  - **Infomaniak DNS plugin**

## Caddy configuration

This image comes with a minimal [default Caddyfile](./Caddyfile.default). You can bring your own configuration to the container by mounting the custom Caddyfile into the container (e.g. using Docker):

```shell
$ docker run [options] -v /path/to/Caddyfile:/etc/caddy/Caddyfile:ro ghcr.io/f-bn/caddy:2.11.4
```