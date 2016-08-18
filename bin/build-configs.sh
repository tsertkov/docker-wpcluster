#!/usr/bin/env bash

eval "$("$(cd "$(dirname "$0")" && pwd)/config.sh")"

get_compose_for_site() {
  SITE_DIR=$1
  SITE_NAME=$2
  CONFIG=$SITE_DIR/config.env

  env -i $(cat "$CONFIG" | xargs) SITE_NAME="$SITE_NAME" \
    sh -c "echo \"$(cat ${ROOT_DIR}/docker-compose.d/wp-service.yml)\"" \
    | sed 's/^/  /'
}

COMPOSE_CONTENT="$(cat "${ROOT_DIR}/docker-compose.d/head.yml")"$'\n'
[ -e "${VAR_DIR}/vhost.d" ] \
  && rm -rf "${VAR_DIR}/vhost.d"/* \
  || mkdir "${VAR_DIR}/vhost.d"

for SITE_DIR in $(find "${VAR_DIR}/sites" -mindepth 1 -maxdepth 1 -type d -not -name '_*'); do
  SITE_NAME=${SITE_DIR##*/}
  COMPOSE_CONTENT+="$(get_compose_for_site "$SITE_DIR" "$SITE_NAME")"$'\n'

  # link site
  [ -d "${SITE_DIR}/vhost.d" ] &&
    ln -s "${SITE_DIR}/vhost.d"/* "${VAR_DIR}/vhost.d/"
done

echo "$COMPOSE_CONTENT" > "${ROOT_DIR}/var/docker-compose.yml"
