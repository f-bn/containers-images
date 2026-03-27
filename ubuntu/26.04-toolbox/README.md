## General informations

Custom Ubuntu 26.04 container image for creating a sandbox environment with utilities such as [toolbx](https://github.com/containers/toolbox) or [distrobox](https://github.com/89luca89/distrobox).

## How to run this image ?

You can use `distrobox` to launch the sandbox using this image:

```shell
$ distrobox create -i ghcr.io/f-bn/ubuntu:26.04-toolbox [options]
```