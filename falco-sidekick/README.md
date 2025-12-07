## General informations

Custom Falco Sidekick image built from source.

Built with Go 1.25.

## Falco Sidekick configuration

This image doesn't come with any default configuration.

You can configure Falco Sidekick using environment variables or by mounting austom configuration file into the container (e.g. using Docker):

```shell
# Using environment variables
$ docker run [options] -e SIDEKICK_WEBHOOK_ADDRESS=http://example.com ghcr.io/f-bn/falco-sidekick:2.32.0

# Mounting custom configuration
$ docker run [options] -v falco-sidekick.yaml:/etc/falco/sidekick.yaml:ro ghcr.io/f-bn/falco-sidekick:2.32.0 -c /etc/falco/sidekick.yaml
```

For more information on available configuration options, see the [Falco Sidekick documentation](https://github.com/falcosecurity/falcosidekick/tree/master/docs/outputs) on GitHub.
