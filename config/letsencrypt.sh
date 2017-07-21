#!/bin/bash -x

### configure apache2 for letsencrypt
mkdir -p /var/www/.well-known/acme-challenge/
cat <<EOF > /etc/apache2/conf-available/letsencrypt.conf
Alias /.well-known/acme-challenge /var/www/.well-known/acme-challenge
<Directory /var/www/.well-known/acme-challenge>
    Options None
    AllowOverride None
    ForceType text/plain
</Directory>
EOF
a2enconf letsencrypt
service apache2 reload

### setup a cron job for renewing the ssl cert periodically
cat <<EOF > /etc/cron.weekly/renew-ssl-cert
#!/bin/bash
certbot renew --webroot --quiet --post-hook='/etc/init.d/apache2 reload'
EOF
chmod +x /etc/cron.weekly/renew-ssl-cert
