FROM debian:bookworm
# install php services
RUN apt-get update && apt-get install -y php php-mysql php-cli wget
RUN mkdir -p /var/www/adminer
RUN wget "http://www.adminer.org/latest.php" -O /var/www/adminer/index.php
EXPOSE 8080
# start adminer with light-weight server inside php
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/adminer"]