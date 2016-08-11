#!/usr/bin/env bash

MYSQL_HOST=mysql
MYSQL=( mysql "-h ${MYSQL_HOST}" "-u ${MYSQL_USER}" "-p${MYSQL_PASSWORD}" )

# wait for the db to be ready
while ! mysqladmin ping -h"$MYSQL_HOST" --silent; do
  echo "Waiting for the MySQL host..."
  sleep 1
done

echo "MySQL host is ready"

for SITE_DIR in $(find /sites -mindepth 1 -maxdepth 1 -type d -not -name '_*'); do
  source "${SITE_DIR}/config.env"

  # create user if necessary
  SQL="SELECT user FROM mysql.user WHERE user='${WORDPRESS_DB_USER}'"
  RES=$(${MYSQL[@]} -e "$SQL")

  if [ $? -eq 0 -a -z "$RES" ]; then
    SQL="GRANT ALL PRIVILEGES ON \`${WORDPRESS_DB_NAME}\`.* TO '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}'"
    RES=$(${MYSQL[@]} -e "$SQL")
    [ $? -eq 0 ] && echo "Created MySQL user: '${WORDPRESS_DB_USER}'"
  fi

  # create db && dump import database
  SQL="SELECT schema_name FROM information_schema.schemata WHERE schema_name='${WORDPRESS_DB_NAME}'"
  RES=$(${MYSQL[@]} -e "$SQL")

  if [ $? -eq 0 -a -z "$RES" ]; then
    SQL="CREATE DATABASE \`${WORDPRESS_DB_NAME}\`"
    RES=$(${MYSQL[@]} -e "$SQL")
    [ $? -eq 0 ] && echo "Created MySQL database: '${WORDPRESS_DB_NAME}'"

    # import dbdump if exists
    DBDUMP=${SITE_DIR}/dbdump.sql.gz
    [ -e "$DBDUMP" ] \
      && gzip -dc "${SITE_DIR}/dbdump.sql.gz" | ${MYSQL[@]} "$WORDPRESS_DB_NAME" \
      && echo "Imported database: '${WORDPRESS_DB_NAME}'"
  fi
done
