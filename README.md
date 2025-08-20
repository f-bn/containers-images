### General informations

This repository contains my personal custom OCI containers images.

#### Images

- [coredns](./coredns/)
- [coreos-toolbox](./coreos-toolbox/)
- [distrobuilder](./distrobuilder/)
- [docker-api-proxy](./docker-api-proxy/)
- [feishin](./feishin/)
- [navidrome](./navidrome/)
- [pgbouncer](./pgbouncer/)
- [postgresql](./postgresql/)
- [traefik](./traefik/)
- [valkey](./valkey/)

#### How to pull the images ?

My images are publicly available through my GitHub Packages namespace:

```shell
docker pull ghcr.io/f-bn/<image>:<tag>
```

### References

- Caddy: https://caddyserver.com/
- CoreDNS: https://coredns.io/
- Distrobuilder: https://github.com/lxc/distrobuilder
- Feishin: https://github.com/jeffvli/feishin
- Navidrome: https://www.navidrome.org/
- PostgreSQL: https://www.postgresql.org/
- pgbouncer: https://www.pgbouncer.org/
- Traefik: https://traefik.io/
- Valkey: https://valkey.io/
- Watchtower: https://containrrr.dev/watchtower/
- WolfiOS: https://github.com/wolfi-dev
