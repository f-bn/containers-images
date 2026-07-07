## 📋 Overview

A custom PostgreSQL image built from sources with additional extensions and tools.

### Supported PostgreSQL versions

- PostgreSQL 18.x
- PostgreSQL 17.x
- PostgreSQL 16.x

### PostgreSQL features support

This image contains a custom PostgreSQL build that differs from the official Docker Hub image since it's not based on upstream packages. Therefore, some features may not be available:

🟢 **Supported**
  - ✅ `lz4` and `zstd` support for **WAL compression**
  - ✅ **OpenSSL** library
  - ✅ **LLVM JIT** compilation
  - ✅ **systemd `sd_notify`** support ([supported](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#notify-defaults-to-false) with Podman Quadlets)
  - ✅ **Data checksums** enabled by default

🔴 **Unsupported**
  - ❌ **GSSAPI** authentication
  - ❌ **LDAP** authentication
  - ❌ **PAM** authentication
  - ❌ **OAuth 2.0** authentication (from PostgreSQL ≥18)
  - ❌ **SQL/XML** support
  - ❌ **XSL** transformations
  - ❌ **Non-native PL extensions** (PL/Tcl, PL/Python, PL/Perl)
  - ❌ **io_uring** support for async I/O methods (from PostgreSQL ≥18, see note below)

> [!WARNING]
> `io_uring` related syscalls are disabled in the default `seccomp` policy of container runtimes such as [Docker](https://github.com/moby/profiles/commit/0e2acd4ddea76ecd4090b04ebe6c53bacad74c50) or [Podman](https://github.com/containers/podman/issues/16796) for security reasons.
> Therefore, this feature is unavailable in containerized PostgreSQL deployments even if the kernel supports it (and disabling container `seccomp` confinement is not a valid solution 😉).

### Included extensions and tools

This image includes the following PostgreSQL extensions and additional tools:

#### Extensions

| Name | Version | Description |
|------|---------|-------------|
| [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) | (bundled with PostgreSQL) | Track planning and execution statistics of all SQL statements executed |
| [pg_prewarm](https://www.postgresql.org/docs/current/pgprewarm.html) | (bundled with PostgreSQL) | Preload relation data into the PostgreSQL buffer cache |
| [pg_cron](https://github.com/citusdata/pg_cron) | 1.6.7 | Run periodic jobs in PostgreSQL |
| [pg_repack](https://github.com/reorg/pg_repack) | 1.5.3 | Reorganize tables in PostgreSQL databases with minimal locks |
| [pg_squeeze](https://github.com/cybertec-postgresql/pg_squeeze) | 1.9.3 | A PostgreSQL extension for automatic bloat cleanup |
| [pg_partman](https://github.com/pgpartman/pg_partman) | 5.4.3 | Partition management extension for PostgreSQL |
| [pgvector](https://github.com/pgvector/pgvector) | 0.8.2 | Open-source vector similarity search for Postgres |
| [pg_stat_monitor](https://github.com/percona/pg_stat_monitor) | 2.3.2 | Query Performance Monitoring Tool for PostgreSQL |
| [timescaledb](https://github.com/timescale/timescaledb) | 2.28.1 | Enables scalable inserts and complex queries for time-series data |

#### Additional tools

| Name | Version | Description |
|------|---------|-------------|
| [pgBackRest](https://pgbackrest.org/) | 2.58.0 | PostgreSQL backup and restore solution
| [pgcopydb](https://github.com/dimitri/pgcopydb) | 0.18 | Copy a Postgres database to a target Postgres server (pg_dump \| pg_restore on steroids)

> [!NOTE]
> The versions listed above are the defaults baked into the image. They are defined as build arguments in the [Dockerfile](./Dockerfile) and can be overridden at build time.

## 🐘PostgreSQL configuration

This image uses the same entrypoint script as the official Docker Hub image, so it inherits the available configuration parameters (such as environment variables and initialization scripts).

### Configuration overrides

At build time, a drop-in folder is created at `/etc/postgresql/config.d` for PostgreSQL configuration overrides. This allows you to add partial configuration chunks without rewriting the entire `postgresql.conf` file if you want to adjust specific parameters.

First, create your configuration override:

```ini
# custom.conf

# I want mooaar cache !
shared_buffers = 2GB

# Let's activate WAL archiving
archive_mode = on
archive_command = '/path/to/my/custom archiving script'
```

Then you can run PostgreSQL with this custom configuration override (e.g., using Docker):

```shell
$ docker run [options] -v $PWD/custom.conf:/etc/postgresql/config.d/custom.conf:ro ghcr.io/f-bn/postgresql:18.1
$ docker exec -ti <name> bash
$ su - postgres -c "psql -c 'SHOW shared_buffers'"
 shared_buffers
----------------
 2GB
```

More information about PostgreSQL configuration [here](https://www.postgresql.org/docs/current/runtime-config.html).

### Loading extensions

Some of the included extensions require libraries to be loaded at server start. This can be done by editing the `shared_preload_libraries` entry in a configuration override as described [above](#configuration-overrides):

```ini
shared_preload_libraries = 'pg_stat_statements,pg_prewarm,pg_cron,pgvector'
```

> [!TIP]
> Extensions already loaded by default (`pg_stat_statements`, `pg_prewarm`) can be omitted from `shared_preload_libraries` if they are not needed.

Extensions can also be configured directly via this override configuration file if needed:

```ini
cron.database_name = 'postgres'
cron.use_background_workers = on
pg_stat_statements.track = all
```

Regardless of whether an extension is preloaded, you need to run `CREATE EXTENSION` where you intend to use it:

```sql
CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION pg_cron;
CREATE EXTENSION pgvector;
```

> [!NOTE]
> Some extensions are enabled globally and affect the entire PostgreSQL cluster (e.g. `pg_cron`), while others must be enabled in each database where you intend to use them (e.g. `pg_stat_statements`). Check each extension's documentation for more information.
