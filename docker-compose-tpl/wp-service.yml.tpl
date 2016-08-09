${SITE_NAME}:
  image: wordpress
  restart: unless-stopped
  links:
    - mysql
  depends_on:
    - db-init
  volumes:
    - \${VAR_DIR}/sites/${SITE_NAME}/wp-content:/var/www/html/wp-content
  environment:
    WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}
    WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
    WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
    VIRTUAL_HOST: ${VIRTUAL_HOST}
