version: '2'
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
    volumes:
      - "${DATA_DIR}/users.sql:/docker-entrypoint-initdb.d/users.sql:ro"
