version: "2"
services:
  nginx-proxy:
    image: jwilder/nginx-proxy
    restart: unless-stopped
    ports:
      - ${PORT}:80
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
  mysql:
    image: mariadb
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: root
  db-init:
    image: mariadb
    restart: "no"
    command: /db-init.sh
    links:
      - mysql
    environment:
      MYSQL_USER: root
      MYSQL_PASSWORD: root
    volumes:
      - "${VAR_DIR}/sites:/sites:ro"
      - "${ROOT_DIR}/bin/db-init.sh:/db-init.sh:ro"
