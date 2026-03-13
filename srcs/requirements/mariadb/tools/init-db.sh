#!/bin/bash

# if data directory not exists, init db
if [! -d "/var/lib/mysql/mysql"]; then
	echo "Initializing MariaDB database..."
	# Create system directories and files
	# e.g.mysql、performance_schema..
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	# Temporary start and set up Wordpress db with bootstrap
	mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi
echo "Start MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql