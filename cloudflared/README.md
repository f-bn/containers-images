## General informations

Custom Cloudflare Tunnel (aka `cloudflared`) image built from sources.

Built with Go 1.22.5.

## Cloudflare Tunnel configuration

This image doesn't come with a default Cloudflare Tunnel configuration, except auto-updates that are disabled. You can bring your own configuration to the container (e.g using Docker):

```shell
$ docker run [options] \
    -v config.yml:/etc/cloudflared/config.yml:ro \
    ghcr.io/f-bn/cloudflared:2025.1.0 --config /etc/cloudflared/config.yml
```

More informations about Cloudflare Tunnel configuration [here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/).