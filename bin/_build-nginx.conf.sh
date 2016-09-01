#!/usr/bin/env bash

eval "$("$(cd "$(dirname "$0")" && pwd)/config.sh")"

if [ ! -f "$VAR_DIR/nginx/nginx.conf" ]; then
  touch "$VAR_DIR/nginx/nginx.conf"
fi
