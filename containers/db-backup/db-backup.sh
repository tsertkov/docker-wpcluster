#!/usr/bin/env bash

MYSQL_HOST=mysql

if ! mysqladmin ping -h"$MYSQL_HOST" --silent; then
  echo "Backup cancelled: MySQL is not ready"
  exit
fi

for SITE_DIR in $(find /sites -mindepth 1 -maxdepth 1 -type d -not -name '_*'); do
  cd "$SITE_DIR"
  source ./config.env

  mysqldump \
    -h "$MYSQL_HOST" \
    -u "$WORDPRESS_DB_USER" \
    -p"$WORDPRESS_DB_PASSWORD" \
    "$WORDPRESS_DB_NAME" \
      | gzip > ./dbdump.sql.gz.new

  if [ $(stat -c %s ./dbdump.sql.gz.new) -lt 100 ]; then
    echo >&2 "Failed dumping database '$WORDPRESS_DB_NAME'"
    rm ./dbdump.sql.gz.new
    continue
  fi

  echo "Dumped database '$WORDPRESS_DB_NAME'"
  mv -f dbdump.sql.gz dbdump.sql.gz.1
  mv dbdump.sql.gz.new dbdump.sql.gz
done
