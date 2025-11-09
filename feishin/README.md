## General informations

Custom Feishin image built from sources and allowing some specific nginx configurations.

Built with NodeJS 24 and nginx 1.29.

## Feishin configuration

Feishin can be configured using the following environment variables:

* **Feishin web server configurations**

  - `FEISHIN_LISTEN_ADDR`: Feishin web server listen address
  - `FEISHIN_LISTEN_PORT`: Feishin web server listen port
  - `FEISHIN_PUBLIC_PATH`: Feishin web server public path

* **Feishin backend server configurations**

  - `FEISHIN_SERVER_TYPE`: backend server type (can be: `navidrome`, `jellyfin` or `subsonic`)
  - `FEISHIN_SERVER_NAME`: backend server name
  - `FEISHIN_SERVER_URL`: backend server URL (e.g `https://music.example.com`)
  - `FEISHIN_SERVER_LOCK`: if set to `true` AND type, name and URL configurations are set, Feishin can only be configured to connect to a single backend server

