#!/bin/bash -x

### create a user 'sshtunnel'
useradd --system --create-home sshtunnel
mkdir -p /home/sshtunnel/.ssh
chown sshtunnel:sshtunnel /home/sshtunnel/.ssh
chmod 700 /home/sshtunnel/.ssh


cat <<_EOF >> /etc/ssmtp/revaliases
sshtunnel:$GMAIL_ADDRESS:smtp.gmail.com:587
_EOF
