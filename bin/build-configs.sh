#!/usr/bin/env bash

source "$(cd "$(dirname "$0")/.." && pwd)/config.env"

get_compose_for_site() {
  SITE_DIR=$1
  SITE_NAME=$2
  CONFIG=$SITE_DIR/config.env

  env -i $(cat "$CONFIG" | xargs) SITE_NAME="$SITE_NAME" \
    sh -c "echo \"$(cat ${ROOT_DIR}/docker-compose-tpl/wp-service.yml.tpl)\"" \
    | sed 's/^/  /'
}

COMPOSE_CONTENT="$(cat "${ROOT_DIR}/docker-compose-tpl/head.yml.tpl")"$'\n'

for SITE_DIR in $(find "${VAR_DIR}/sites" -mindepth 1 -maxdepth 1 -type d -not -name '_*'); do
  SITE_NAME=${SITE_DIR##*/}
  COMPOSE_CONTENT+="$(get_compose_for_site "$SITE_DIR" "$SITE_NAME")"$'\n'
done

echo "$COMPOSE_CONTENT" > "${ROOT_DIR}/var/docker-compose.yml"
