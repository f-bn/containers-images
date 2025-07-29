## General informations

Custom Garage image built from sources.

Built with Rust 1.88.0

## Garage configuration

This image come with a minimal default Garage [configuration](./garage.default.toml) for single node setup with only the S3 API enabled.

You can also bring your own configuration file for more advanced setups (e.g using Docker):

```shell
$ docker run [options] -e GARAGE_RPC_SECRET="$(openssl rand -hex 32)" \
  -v path/to/garage.toml:/etc/garage.toml:ro \
  -v path/to/dir:/var/lib/garage:rw \
  ghcr.io/f-bn/garage:2.0.0
```

More informations about Garage configuration [here](https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/).