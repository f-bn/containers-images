## General informations

Custom Ubuntu 24.04 system container image (with systemd as entrypoint).

## How to run this image ?

In order to launcher a Docker container with systemd as main process, a set of options must be set to ensure the correct execution:

```shell
$ docker run [options] \
  --env=container="docker" \ # optional as set in the image
  --stop-signal=SIGRTMIN+3 \ # optional as set in the image
  --cgroupns=host \
  --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
  --tmpfs=/run \
  --tmpfs=/run/lock \
  --tmpfs=/tmp \
  --tmpfs=/var/lib/journal \
  [image]
```