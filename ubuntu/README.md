## General informations

This folder contains two types of Ubuntu container images:

### 🖥️ System container images (init)

System container images with `systemd` as the main entrypoint. Designed for testing and debugging purposes that require a full system environment with service management.

### 🧰 Sandbox images (toolbox)

Development/utility images designed for use with tools like [toolbx](https://github.com/containers/toolbox) or [distrobox](https://github.com/89luca89/distrobox) to create sandbox environments.