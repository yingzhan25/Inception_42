#!/bin/bash

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/my_password)
MYSQL_PASSWORD=$(cat /run/secrets/my_password)

set -e

DATADIR=/var/lib/mysql
MARKER_FILE="$DATADIR/.inception_initialized"

# Ensure datadir is writable by mysql when bind-mounted
chown -R mysql:mysql "$DATADIR"

if [ ! -f "$MARKER_FILE" ]; then
	echo "Initializing MariaDB database..."

	# Create system tables if missing
	if [ ! -d "$DATADIR/mysql" ]; then
		mysql_install_db --user=mysql --datadir="$DATADIR"
	fi

	# Run bootstrap SQL to ensure root password, DB, user and grants exist
	mysqld --user=mysql --datadir="$DATADIR" --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	touch "$MARKER_FILE"
	chown mysql:mysql "$MARKER_FILE"
fi

echo "Start MariaDB..."
exec mysqld --user=mysql --datadir="$DATADIR"