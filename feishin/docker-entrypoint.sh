#!/usr/bin/env sh

set -e

envsubst < /etc/caddy/templates/Caddyfile.tmpl > /etc/caddy/conf.d/Caddyfile
envsubst < /etc/caddy/templates/settings.js.tmpl > /etc/caddy/conf.d/settings.js

exec gosu nonroot:nonroot "$@"