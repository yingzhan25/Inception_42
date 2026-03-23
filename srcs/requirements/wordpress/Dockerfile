# Use penultimate stable Debian as base image
FROM debian:bookworm
# Install php-fpm and other php extensions
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-soap \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-zip \
    wget \
    curl \
	mariadb-client \
	redis-tools \
    && rm -rf /var/lib/apt/lists/*
# Install WP-CLI && add permission && move to sys directory
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp
# Create wp file directory
# Change owner to default Web user in Debian
RUN mkdir -p /var/www/html && \
	chown -R www-data:www-data /var/www/html
# Replace Unix socket with tcp port listening in conf
# to connect with Nginx
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf
# Copy init file to system directory
COPY tools/wordpress-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh
WORKDIR /var/www/html
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/wordpress-entrypoint.sh"]