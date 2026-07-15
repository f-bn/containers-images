## General informations

Custom Caddy image built from sources using xcaddy.

Built with Go 1.26 and Caddy v2.11.4.

**This image is running by default with a non-root user** (caddy:999).

### Image notes

This image contains a custom Caddy build with the following plugin:

  - **Infomaniak DNS plugin** for DNS challenge support

## Caddy configuration

This image comes with a minimal [default Caddyfile](./Caddyfile.default). You can bring your own configuration to the container by mounting the custom Caddyfile into the container (e.g. using Docker):

```shell
$ docker run [options] -v /path/to/Caddyfile:/etc/caddy/Caddyfile:ro ghcr.io/f-bn/caddy:2.11.4
```