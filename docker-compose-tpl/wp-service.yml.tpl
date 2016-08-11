${SITE_NAME}:
  image: wordpress
  restart: unless-stopped
  links:
    - mysql
  depends_on:
    - db-init
  volumes:
    - \${VAR_DIR}/sites/${SITE_NAME}/wp-content:/var/www/html/wp-content:ro
    - \${VAR_DIR}/sites/${SITE_NAME}/wp-content/uploads:/var/www/html/wp-content/uploads
    - \${ROOT_DIR}/containers/wordpress/apache-wordpress.conf:/etc/apache2/conf-enabled/xxx-wordpress.conf:ro
    - \${ROOT_DIR}/containers/wordpress/php.ini-\${ENV}:/usr/local/etc/php/php.ini:ro
  environment:
    WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}
    WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
    WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
    VIRTUAL_HOST: ${VIRTUAL_HOST}
