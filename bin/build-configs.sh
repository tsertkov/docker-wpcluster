#!/usr/bin/env bash

eval "$("$(cd "$(dirname "$0")" && pwd)/config.sh")"
cd "$ROOT_DIR/bin"
./_build-docker-compose.yml.sh
./_build-nginx.conf.sh
