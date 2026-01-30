## General informations

Custom Ubuntu 25.10 container image for creating a sandbox environment with utilities such as [toolbx](https://github.com/containers/toolbox) or [distrobox](https://github.com/89luca89/distrobox).

### Image notes

This image is using classic GNU coreutils instead of the new Rust-based coreutils (a.k.a `uutils`) that are used by default since 25.10 release.

## How to run this image ?

You can use `distrobox` to launch the sandbox using this image:

```shell
$ distrobox create -i ghcr.io/f-bn/ubuntu:25.10-toolbox [options]
```