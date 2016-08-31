#!/usr/bin/env bash

eval "$("$(cd "$(dirname "$0")" && pwd)/config.sh")"
[ ! -f "$VAR_DIR/nginx/nginx.conf" ] && touch "$VAR_DIR/nginx/nginx.conf"
