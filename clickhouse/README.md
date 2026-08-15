## 📋 Overview

Custom ClickHouse image built from official static binaries.

By default, this repository builds only **stable** ClickHouse releases.

## 🏠 ClickHouse configuration

This image uses the `docker-init` entrypoint embedded in the ClickHouse binary, as does the official `distroless` image variant. It therefore supports the available configuration options, including environment variables and initialization scripts.

### Configuration overrides

To add or override settings, place a configuration file in the appropriate directory:

- `/etc/clickhouse-server/config.d` - Overrides server settings
- `/etc/clickhouse-server/users.d` - Overrides users and profiles
- `/etc/clickhouse-keeper/config.d` - Overrides ClickHouse Keeper settings
- `/etc/clickhouse-client/config.d` - Overrides client settings

> [!NOTE]
> A [default configuration override](./config.docker.xml) is already embedded in the image to configure ClickHouse to run in Docker or Podman:
> - Listen on all interfaces (IPv4 and IPv6)
> - Log only to the container's standard output and error streams, using a less verbose mode.
>
> The file is located in `/etc/clickhouse-server/config.d/00-docker.xml`.

To add a custom override, first create a configuration file:

```xml
<clickhouse>
    <logger>
        <level>debug</level>
    </logger>
</clickhouse>
```

Then,, run ClickHouse with the custom configuration (for example, using Docker):

```shell
docker run [options] -v $PWD/custom.xml:/etc/clickhouse-server/config.d/10-custom.xml:ro ghcr.io/f-bn/clickhouse:26.7.3.19
```

> [!IMPORTANT]
> ClickHouse merges configuration files **in alphabetical order**. Choose the filename carefully when mounting a custom configuration into the container so that it is applied in the intended order. For example, the files are loaded in this order:
> - `/etc/clickhouse-server/config.xml`
> - `/etc/clickhouse-server/config.d/00-docker.xml`
> - `/etc/clickhouse-server/config.d/90-custom.xml`
>
> If `00-docker.xml` and `90-custom.xml` define the same setting, the value from `90-custom.xml` takes priority.

See the [ClickHouse configuration documentation](https://clickhouse.com/docs/concepts/features/configuration/settings/overview) for more information.
