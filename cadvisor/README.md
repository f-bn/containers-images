## General informations

Custom cAdvisor image built from sources.

Built with Go 1.24.

## cAdvisor configuration

This image works exactly as the official image, the cAdvisor configuration is done using flags:

```shell
# Regular way of running cAdvisor
$ docker run [options] --name cadvisor \
   -p 8080:8080 \
    --volume="/:/rootfs:ro" \
    --volume="/sys:/sys:ro" \
    --volume="/var/run:/var/run:ro" \
    --volume="/var/lib/docker/:/var/lib/docker:ro" \
    --volume="/dev/disk/:/dev/disk:ro" \
    --privileged \
  ghcr.io/f-bn/cadvisor:0.53.0 \
    --docker_only=true \
    --store_container_labels=false

# With peage (https://github.com/f-bn/peage)
# Start peage first because cadvisor won't retry on it's own to connect to the socket proxy.
# In this mode, the socket proxy must create the port forwarding as cAdvisor will join the 
# peage container netns.
docker run [options] --name peage \
  -p 8080:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/f-bn/peage:0.3.0

docker run [options] --name cadvisor \
    --volume="/:/rootfs:ro" \
    --volume="/sys:/sys:ro" \
    --volume="/var/lib/docker/:/var/lib/docker:ro" \
    --volume="/dev/disk/:/dev/disk:ro" \
    --net=container:peage \
  ghcr.io/f-bn/cadvisor:0.53.0 \
    --docker=tcp://127.0.0.1:2375 \
    --docker_only=true \
    --store_container_labels=false
```