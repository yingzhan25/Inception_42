# Use penultimate stable Debian as base image
From debian:bookworm
# Install MariaDB and remove cache lists
RUN apt-get update && apt-get install -y \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*
# Make a directory for socket tmp file
# Change its owner to mysql:mysql(system user)
# Give permission
RUN mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld
# Copy .cnf to path in the image/container
# MariaDB reads this .cnf instead of default
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# Copy script to path in container and give permission
# Enable creating db, users...
COPY tools/init-db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-db.sh
# Declare to expose port 3306
Expose 3306
# Run this script automatically when container starts
# mysqld replaces shell becoming PID1
# Continue in frontend until stop or crash
ENTRYPOINT ["/usr/local/bin/init-db.sh"]