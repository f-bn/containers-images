## General informations

Custom PostgreSQL image based on the official image with additional embedded extensions, configuration and tools for learning and testing purposes.

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
  - [pg_qualstats](https://github.com/powa-team/pg_qualstats)
  - [pgvector](https://github.com/pgvector/pgvector)
  - [pg_stat_kcache](https://github.com/powa-team/pg_stat_kcache)
  - pg_stat_statements - **loaded by default**
  - pg_prewarm - **loaded by default**

### Additional tools

This image also embeds some famous PostgreSQL tools:
  - [pgbackrest](https://github.com/pgbackrest/pgbackrest)
  - [pg_activity](https://github.com/dalibo/pg_activity)

## PostgreSQL configuration

Since this image is based on the official image from the Docker Hub, therefore it inherits the available configuration parameters (such environment variables and initialization scripts).

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