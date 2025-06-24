## General informations

Custom Feishin image with application tree embedded in a custom Caddy binary (using Caddy virtual filesystem).

Built with NodeJS 23 and Caddy 2.10.0.

## Feishin configuration

Feishin can be configured using the following environment variables:

* **Feishin web server configurations**

  - `FEISHIN_LISTEN_ADDR`: Feishin web server listen address (default: `localhost`)
  - `FEISHIN_LISTEN_PORT`: Feishin web server listen port (default: `9180`)
  - `FEISHIN_PUBLIC_PATH`: Feishin web server public path (default: `/`)

* **Feishin backend server configurations**

  - `FEISHIN_SERVER_TYPE`: backend server type (can be: `navidrome`, `jellyfin` or `subsonic`)
  - `FEISHIN_SERVER_NAME`: backend server name
  - `FEISHIN_SERVER_URL`: backend server URL (e.g `https://music.example.com`)
  - `FEISHIN_SERVER_LOCK`: if set to `true` AND type, name and URL configurations are set, Feishin can only be configured to connect to a single backend server

