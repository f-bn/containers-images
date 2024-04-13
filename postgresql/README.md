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

## PostgreSQL configuration overrides

At build time, a drop-in folder is created to allow to push some PostgreSQL configuration overrides. This helps to avoid to push a complete `postgresql.conf` file if you just want to test some configuration parameters:

```ini
# mypostgresql.conf

# I want moar caaccchheee
shared_buffers = 2GB

# Let's active WAL archiving
archive_mode = on
archive_command = '/path/to/my/custom archiving script'
```

You can now run PostgreSQL with this custom configuration chunk (e.g using Docker):

```shell
$ docker run [options] -v mypostgresql.conf:/etc/postgresql/postgresql.conf.d/mypostgresql.conf ghcr.io/f-bn/postgresql:16.2
```

More informations about PostgreSQL configuration [here](https://www.postgresql.org/docs/current/runtime-config.html).