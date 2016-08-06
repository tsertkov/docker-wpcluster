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

get_grant_for_site() {
  SITE_DIR=$1
  CONFIG=$SITE_DIR/config.env

  env -i $(cat "$CONFIG" | xargs) \
    sh -c '
      echo \
        GRANT ALL PRIVILEGES \
        ON ${WORDPRESS_DB_NAME}.* \
        TO \'\''${WORDPRESS_DB_USER}\'\''@\'\''%\'\'' \
        IDENTIFIED BY \'\''${WORDPRESS_DB_PASSWORD}\'\'';
    '
}

COMPOSE_CONTENT="$(cat "${ROOT_DIR}/docker-compose-tpl/head.yml.tpl")"$'\n'
GRANT_SQL=

for SITE_DIR in $(find "${VAR_DIR}/sites" -type d -not -name '_*' -depth 1); do
  SITE_NAME=${SITE_DIR##*/}
  COMPOSE_CONTENT+="$(get_compose_for_site "$SITE_DIR" "$SITE_NAME")"$'\n'
  GRANT_SQL+="$(get_grant_for_site "$SITE_DIR")"$'\n'
done

echo "$COMPOSE_CONTENT" > "${ROOT_DIR}/var/docker-compose.yml"
echo "$GRANT_SQL" > "${ROOT_DIR}/var/users.sql"
