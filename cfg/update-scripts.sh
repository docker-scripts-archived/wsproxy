#!/bin/bash -x

### create a script to update /home/sshtunnel/.ssh/authorized_keys inside the container
cat <<'EOF' > /usr/local/sbin/update-authorized-keys.sh
#!/bin/bash
keys=/home/sshtunnel/.ssh/authorized_keys
cat /home/sshtunnel/keys/*.pub > $keys 2> /dev/null
chown sshtunnel:sshtunnel $keys
chmod 600 $keys
EOF
chmod +x /usr/local/sbin/update-authorized-keys.sh
