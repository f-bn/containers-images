## General informations

Custom PostgreSQL image built from sources with additional extensions, configuration and tools.

Built with GCC 14.2.

### Supported PostgreSQL versions

- PostgreSQL 16.x
- PostgreSQL 15.x
- PostgreSQL 14.x

### Embedded extensions

This image embeds the following additional extensions:
  - [pgaudit](https://github.com/pgaudit/pgaudit)
  - [pg_cron](https://github.com/citusdata/pg_cron)
  - [pg_repack](https://github.com/reorg/pg_repack)
  - [pg_partman](https://github.com/pgpartman/pg_partman)
  - pg_stat_statements - **loaded by default**
  - pg_prewarm - **loaded by default**

### Additional tools

This image also embeds some famous PostgreSQL tools:

## PostgreSQL configuration

This image is mostly compatible with the [official image](https://hub.docker.com/_/postgres/), it inherits the available configuration parameters such as environment variables and initialization scripts.

At build time, a drop-in folder located at `/etc/postgresql/config.d` is created to push some PostgreSQL configuration overrides. This allows to push partial PostgreSQL configuration chunks without having to rewrite a complete `postgresql.conf` file if you just want to play with some configuration parameters.

First, create your configuration override:

```ini
# custom.conf

# I want mooaar cache !
shared_buffers = 2GB

# Let's activate WAL archiving
archive_mode = on
archive_command = '/path/to/my/custom archiving script'
```

Then, you can now run PostgreSQL with this custom configuration override (e.g using Docker):

```shell
$ docker run [options] -v $PWD/custom.conf:/etc/postgresql/config.d/custom.conf:ro ghcr.io/f-bn/postgresql:16.2
$ docker exec -ti <name> bash
$ su - postgres -c "psql -c 'SHOW shared_buffers'"
 shared_buffers
----------------
 2GB
```

More informations about PostgreSQL configuration [here](https://www.postgresql.org/docs/current/runtime-config.html).