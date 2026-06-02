## General informations

Custom Fedora 44 container image for creating a sandbox environment with utilities such as [toolbx](https://github.com/containers/toolbox) or [distrobox](https://github.com/89luca89/distrobox).

## How to run this image ?

You can use `distrobox` to launch the sandbox using this image:

```shell
$ distrobox create -i ghcr.io/f-bn/fedora:44-toolbox [options]
```