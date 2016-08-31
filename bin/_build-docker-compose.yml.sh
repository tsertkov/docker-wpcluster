#!/usr/bin/env bash

eval "$("$(cd "$(dirname "$0")" && pwd)/config.sh")"

get_compose_for_site() {
  SITE_DIR=$1
  SITE_NAME=$2
  CONFIG=$SITE_DIR/config.env

  if [ -e "${SITE_DIR}/wp-service.yml" ]; then
    COMPOSE_TPL=${SITE_DIR}/wp-service.yml
  else
    COMPOSE_TPL=${ROOT_DIR}/docker-compose.d/wp-service.yml
  fi

  env -i $(cat "$CONFIG" | xargs) SITE_NAME="$SITE_NAME" \
    sh -c "echo \"$(cat ${COMPOSE_TPL})\"" \
    | sed 's/^/  /'
}

COMPOSE_CONTENT="$(cat "${ROOT_DIR}/docker-compose.d/header.yml")"$'\n'

for SITE_DIR in $(find "${VAR_DIR}/sites" -mindepth 1 -maxdepth 1 -type d -not -name '_*'); do
  SITE_NAME=${SITE_DIR##*/}
  COMPOSE_CONTENT+="$(get_compose_for_site "$SITE_DIR" "$SITE_NAME")"$'\n'
done

COMPOSE_CONTENT+="$(cat "${ROOT_DIR}/docker-compose.d/footer.yml")"$'\n'
echo "$COMPOSE_CONTENT" > "${ROOT_DIR}/var/docker-compose.yml"
