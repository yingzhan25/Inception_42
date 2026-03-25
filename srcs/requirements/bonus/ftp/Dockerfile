FROM debian:bookworm

# install vsftpd
RUN apt-get update && apt-get install -y vsftpd

# make safe chroot dir
RUN mkdir -p /var/run/vsftpd/empty

# copy conf and init files and change permission
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 21 21100-21110
CMD ["/usr/local/bin/run.sh"]