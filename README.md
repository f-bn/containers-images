### General informations

This repository contains my personal custom OCI containers images.

#### Images

- [alertmanager](./alertmanager/)
- [coredns](./coredns/)
- [coreos-toolbox](./coreos-toolbox/)
- [distrobuilder](./distrobuilder/)
- [feishin](./feishin/)
- [grafana](./grafana/)
- [navidrome](./navidrome/)
- [node-exporter](./node-exporter/)
- [pgbouncer](./pgbouncer/)
- [podman-exporter](./podman-exporter/)
- [postgresql](./postgresql/)
- [prometheus](./prometheus/)
- [telegraf](./telegraf/)
- [traefik](./traefik/)
- [ubuntu](./ubuntu/)
- [valkey](./valkey/)

#### How to pull the images ?

My images are publicly available through my GitHub Packages namespace:

```shell
docker pull ghcr.io/f-bn/<image>:<tag>
```

### References

- Alertmanager: https://github.com/prometheus/alertmanager
- CoreDNS: https://coredns.io/
- Distrobuilder: https://github.com/lxc/distrobuilder
- Feishin: https://github.com/jeffvli/feishin
- Grafana: https://grafana.com/
- Navidrome: https://www.navidrome.org/
- Node Exporter: https://github.com/prometheus/node_exporter
- Podman Exporter: https://github.com/containers/prometheus-podman-exporter
- PostgreSQL: https://www.postgresql.org/
- pgbouncer: https://www.pgbouncer.org/
- Prometheus: https://prometheus.io/
- Telegraf: https://github.com/influxdata/telegraf
- Traefik: https://traefik.io/
- Valkey: https://valkey.io/
- WolfiOS: https://github.com/wolfi-dev
