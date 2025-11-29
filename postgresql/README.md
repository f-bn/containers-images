## 📋 Overview

A custom PostgreSQL image built from sources with additional extensions and tools.

### Supported PostgreSQL versions

- PostgreSQL 18.x
- PostgreSQL 17.x
- PostgreSQL 16.x

### Included extensions

This image embeds the following additional extensions:
  - [pg_cron](https://github.com/citusdata/pg_cron)
  - [pg_repack](https://github.com/reorg/pg_repack)
  - [pg_partman](https://github.com/pgpartman/pg_partman)
  - [pgvector](https://github.com/pgvector/pgvector)
  - [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) - **loaded by default**
  - [pg_prewarm](https://www.postgresql.org/docs/current/pgprewarm.html) - **loaded by default but not enabled**

The default versions used for those extensions can be found in the [Dockerfile](./Dockerfile#L55-58).

### Included tools

This image includes the following additional tools:
  - [pgBackRest](https://pgbackrest.org/) - PostgreSQL backup and restore solution

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
  - ❌ **io_uring** support for async I/O methods\* (from PostgreSQL ≥18)

\* `io_uring` related syscalls are disabled in the default `seccomp` policy of container runtimes such as [Docker](https://github.com/moby/profiles/commit/0e2acd4ddea76ecd4090b04ebe6c53bacad74c50) or [Podman](https://github.com/containers/podman/issues/16796) for security reasons. Therefore, this feature is unavailable in containerized PostgreSQL deployments even if the kernel supports it (and disabling container `seccomp` confinement is not a valid solution 😉).

## 🛠️ PostgreSQL configuration

This image uses the same entrypoint script as the official Docker Hub image, so it inherits the available configuration parameters (such as environment variables and initialization scripts).

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