# syntax=docker/dockerfile:1

# The official image already ships Apache, PHP and the WordPress bootstrap
# (docker-entrypoint.sh renders wp-config.php from the WORDPRESS_* env vars),
# so nothing else is needed here.
FROM wordpress:php8.5-apache

# Custom themes/plugins can later be baked into the image like this:
#   COPY my-theme/  /usr/src/wordpress/wp-content/themes/my-theme/
#   COPY my-plugin/ /usr/src/wordpress/wp-content/plugins/my-plugin/
