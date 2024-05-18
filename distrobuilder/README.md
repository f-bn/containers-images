## General informations

Custom Distrobuilder images built from sources. Two image versions are available, from the latest stable version and from the latest main branch commit.

Built with Go 1.22.3.

## Distrobuilder usage in container

```shell
$ docker run \
    -ti --rm \
    --net=host \
    --cap-add SYS_ADMIN \
    --tmpfs /var/cache/distrobuilder \
     -v $PWD:/build \
     ghcr.io/f-bn/distrobuilder:3.0 build-incus file.yml [options]
```