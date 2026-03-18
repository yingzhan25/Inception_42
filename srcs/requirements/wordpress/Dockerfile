# Use penultimate stable Debian as base image
From debian:bookworm
# Install php-fpm and other php extensions
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    wget \
    curl \
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
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf
# Copy init file to system directory
COPY tools/wordpress-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh
WORKDIR /var/www/html
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/wordpress-entrypoint.sh"]