## General informations

Custom Fedora 44 system container image for testing and debugging purposes.

This image uses `systemd` as entrypoint to create a lightweight "system" environment.

## How to run this image ?

In order to launch a Docker container with systemd as main process, a set of specific options must be set to ensure the correct execution of `systemd` in such environment:

```shell
$ docker run [options] \
  --detach \
  --tty \
  --env=container="docker"\  # optional as set in the image
  --stop-signal=SIGRTMIN+3 \ # optional as set in the image
  --cgroupns=private \
  --security-opt=writable-cgroups=true \
  --tmpfs=/run \
  --tmpfs=/run/lock \
  --tmpfs=/tmp \
  ghcr.io/f-bn/fedora:44-init
```