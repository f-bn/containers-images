## General informations

Custom PgBouncer image built from sources.

### Supported PgBouncer versions

- PgBouncer 1.25.x
- PgBouncer 1.24.x

## PgBouncer configuration

By default, this image is built with a default empty PgBouncer configuration. You can bring your own configuration to the container (e.g using Docker):

```shell
# By default, the image is looking for configuration in /etc/pgbouncer/pgbouncer.ini
$ docker run [options] -v pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini ghcr.io/f-bn/pgbouncer:1.22.0
```

More informations about PgBouncer configuration [here](https://www.pgbouncer.org/config.html).