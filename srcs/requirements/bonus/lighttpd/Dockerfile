FROM debian:bookworm
RUN apt-get update && apt-get install -y lighttpd
# copy html files to web root dir
COPY html/ /var/www/html/
EXPOSE 80
# use default configuration file
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]