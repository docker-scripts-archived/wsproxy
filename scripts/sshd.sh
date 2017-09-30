#!/bin/bash -x

### customize the configuration of sshd
sed -i /etc/ssh/sshd_config \
    -e 's/^GatewayPorts/#GatewayPorts/' \
    -e 's/^PermitRootLogin/#PermitRootLogin/' \
    -e 's/^PasswordAuthentication/#PasswordAuthentication/' \
    -e 's/^X11Forwarding/#X11Forwarding/' \
    -e 's/^UseLogin/#UseLogin/' \
    -e 's/^AllowUsers/#AllowUsers/'

sed -i /etc/ssh/sshd_config \
    -e '/^### wsproxy config/,$ d'

cat <<EOF >> /etc/ssh/sshd_config
### wsproxy config
GatewayPorts yes
PermitRootLogin no
PasswordAuthentication no
X11Forwarding no
UseLogin no
AllowUsers sshtunnel
EOF
