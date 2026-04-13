## General informations

Custom OAuth2 Proxy image built from sources.

Built with Go 1.26.

## Oauth2 Proxy configuration

This image works exactly as the official image, the OAuth2 Proxy configuration is done using environment variables, flags or via a config file mounted in the container using bind-mount:

```shell
$ docker run [options] ghcr.io/f-bn/oauth2-proxy:7.15.1 [flags]

$ docker run [options] -v config.toml:/etc/oauth2-proxy/config.toml:ro \
    ghcr.io/f-bn/oauth2-proxy:7.15.1 --config /etc/oauth2-proxy/config.toml
```