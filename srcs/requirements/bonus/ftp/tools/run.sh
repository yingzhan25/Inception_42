#!/bin/bash
# add bash to /etc/shells
echo "/bin/bash" >> /etc/shells
# add new user in wordpress volume dir
useradd -m -d /var/www/html -s /bin/bash "$FTP_USER" || true
# change password
echo "$FTP_USER:$FTP_PWD" | chpasswd
# give dir permission to ftp user
chown -R $FTP_USER:$FTP_USER /var/www/html
# start vsftpd
/usr/sbin/vsftpd /etc/vsftpd.conf