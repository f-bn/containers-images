## General informations

Custom Caddy image built from sources with specific configuration for proxying Docker socket to limit access to Docker API.

Built with Go 1.23.5

## Why creating this image ?

The image goal is to provide the most simple solution for limiting Traefik access to the Docker API through the socket. Therefore, this allows to not running Traefik as root and not mounting the Docker socket inside the Traefik container (that could lead to a pretty bad privilege escalation if Traefik is compromised).

For a more flexible solution for multiple other use-cases, prefer [docker-socket-proxy](https://github.com/Tecnativa/docker-socket-proxy) from Tecnativa.

## Image configuration

This image come with a specific Caddy configuration for the use-case described above. The reverse proxy server listens on `http://localhost:2375` and will forward request to the Docker UNIX domain socket mounted inside this container.

However only `GET` method on a specific set of Docker API endpoints are allowed:
- `/info`
- `/events`
- `/networks`
- `/containers/json`
- `/containers/<container id>/json`
- `/version`

For any other methods and/or endpoints called, a 403 error is returned. Moreover, endpoints required for Docker Swarm are not considered.

You can find a basic [docker-compose.yml](./examples/docker-compose.yml) in the `examples` folder showing a barebone configuration using this container image (i.e absolutely not production-ready).