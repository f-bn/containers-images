<div align="center">
  <img src="https://raw.githubusercontent.com/opencontainers/artwork/master/oci/icon/color/oci-icon-color.png" alt="OCI Logo" width="150"/>

  **Personal OCI container images**

  ---
</div>

## 📋 Overview

[![License](https://img.shields.io/github/license/f-bn/containers-images)](./LICENSE)
[![GitHub Actions](https://img.shields.io/badge/CI-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/f-bn/containers-images/actions)

This repository contains custom-built OCI container images for various popular open-source projects I use for personal projects and home production.

- 🔨 **Built from source** - Built from source whenever possible  
- ⚡ **Optimized builds** - Built with custom build options to remove uneeded features and reduce attack surface  
- 🛡️ **Secure base** - Uses [Wolfi](https://github.com/wolfi-dev) as minimal base image

## 📦 Available Images

| Image | Description | Links |
|-------|-------------|-------|
| **[alertmanager](./alertmanager/)** | Prometheus Alertmanager | [GitHub](https://github.com/prometheus/alertmanager) |
| **[coredns](./coredns/)** | CoreDNS is a DNS server that chains plugins | [Website](https://coredns.io/) |
| **[caddy](./caddy/)** | Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS | [Website](https://caddyserver.com/) |
| **[centos](./centos/)** | Custom CentOS Stream container images | [Website](https://www.centos.org/) |
| **[coreos-toolbox](./coreos-toolbox/)** | Custom Fedora image including utilities and tools for debugging on Fedora CoreOS | - |
| **[fedora](./fedora/)** | Custom Fedora containers images | [Website](https://fedoraproject.org/) |
| **[fusion](./fusion/)** | A lightweight, self-hosted friendly RSS reader | [GitHub](https://github.com/0x2E/fusion) |
| **[grafana](./grafana/)** | The open and composable observability and data visualization platform | [Website](https://grafana.com/) |
| **[navidrome](./navidrome/)** | Modern Music Server and Streamer compatible with Subsonic/Airsonic | [Website](https://www.navidrome.org/) |
| **[oauth2-proxy](./oauth2-proxy/)** | A reverse proxy that provides authentication with Google, Azure, OpenID Connect and many more identity providers | [GitHub](https://github.com/oauth2-proxy/oauth2-proxy) |
| **[pgbouncer](./pgbouncer/)** | Lightweight connection pooler for PostgreSQL | [Website](https://www.pgbouncer.org/) |
| **[plik](./plik/)** | Plik is a temporary file upload system (Wetransfer like) in Go | [GitHub](https://github.com/root-gg/plik) |
| **[pocket-id](./pocket-id/)** | A simple and easy-to-use OIDC provider that allows users to authenticate with their passkeys to your services | [GitHub](https://github.com/pocket-id/pocket-id) |
| **[postgresql](./postgresql/)** | Custom PostgreSQL image built from source with additional extensions and tools | [Website](https://www.postgresql.org/) |
| **[prometheus](./prometheus/)** | The Prometheus monitoring system and time series database | [Website](https://prometheus.io/) |
| **[telegraf](./telegraf/)** | Agent for collecting, processing, aggregating, and writing metrics, logs, and other arbitrary data | [GitHub](https://github.com/influxdata/telegraf) |
| **[traefik](./traefik/)** | The Cloud Native Application Proxy | [Website](https://traefik.io/) |
| **[valkey](./valkey/)** | An open source, in-memory data store | [Website](https://valkey.io/) |

## 🚀 Quick Start

All images are publicly available through GitHub Container Registry:

```bash
# Pull an image
docker pull ghcr.io/f-bn/<image>:<tag>

# Example: Pull specific version
docker pull ghcr.io/f-bn/prometheus:3.7.3
```

## 🛠️ Building Locally

Each image directory contains its own `Dockerfile` and usage instructions. To build an image locally:

```bash
cd <image-directory>
docker build -t <image-name>:<tag> [--build-arg VERSION=x.x.x] -f Dockerfile .
```

## License

See [LICENSE](./LICENSE) file for details.