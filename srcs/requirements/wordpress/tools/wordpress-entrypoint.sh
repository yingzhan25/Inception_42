#!/bin/bash

MYSQL_PASSWORD=$(cat /run/secrets/my_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/my_password)
WP_USER_PASSWORD=$(cat /run/secrets/my_password)

# Waiting until MariaDB is ready
echo "Wait MariaDB..."
while ! MYSQL_PWD="$MYSQL_PASSWORD" mysqladmin ping -h"mariadb" -u"$MYSQL_USER" --silent; do
    sleep 1
done
# Download WordPress if wp-config.php not found
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Download WordPress..."
    wp core download --allow-root
    # Set up wp-config.php
    echo "Configure WordPress..."
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306 \
        --allow-root
	# Set up WordPress
    echo "Set up WordPress..."
    wp core install \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root
	# Create regular user
	echo "Create regular user..."
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author \
        --allow-root

	echo "Waiting for Redis..."
	while ! redis-cli -h redis -p 6379 ping | grep -q PONG; do
		sleep 2
	done

	echo "Configuring Redis cache..."
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_REDIS_PORT 6379 --raw --allow-root
	wp plugin install redis-cache --activate --allow-root
	wp redis enable --allow-root

	# Change permission from root to www-data
    chown -R www-data:www-data /var/www/html
	echo "WordPress + Redis setup complete!"
fi

echo "Start PHP-FPM..."
# php-fpm running at frontend
exec php-fpm8.2 -F
