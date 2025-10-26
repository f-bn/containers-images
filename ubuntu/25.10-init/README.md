## General informations

Custom Ubuntu 25.10 system container image for testing and debugging purposes.

This image uses `systemd` as entrypoint to create a lightweight "system" environment.

### Image notes

This image is using classic GNU coreutils instead of the new Rust-based coreutils (a.k.a `uutils`) that are used by default since 25.10 release.

## How to run this image ?

In order to launch a Docker container with systemd as main process, a set of specific options must be set to ensure the correct execution of `systemd` in such environment:

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
  ghcr.io/f-bn/ubuntu:25.10-init
```