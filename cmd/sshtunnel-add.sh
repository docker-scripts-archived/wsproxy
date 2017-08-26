cmd_sshtunnel-add_help() {
    cat <<_EOF
    sshtunnel-add <domain>
        Setup a domain to be served by a remote web server through a ssh tunnel.

_EOF
}

cmd_sshtunnel-add() {
    # get the domain
    [[ $1 == '' ]] && fail "Usage: $COMMAND <domain>"
    local domain=$1

    # remove the domain, if it exists
    ds sshtunnel-rm $domain

    # -------------------------------------------------

    # find a pair of unused ports for http and https
    cat sshtunnel-keys/*.ports > sshtunnel-keys/ports.txt
    local port_http=$(shuf -i 1025-65535 -n 1)
    while grep -qs $port_http sshtunnel-keys/ports.txt; do
        port_http=$(shuf -i 1025-65535 -n 1)
    done
    echo $port_http >> sshtunnel-keys/ports.txt
    local port_https=$(shuf -i 1025-65535 -n 1)
    while grep -qs $port_https sshtunnel-keys/ports.txt; do
        port_https=$(shuf -i 1025-65535 -n 1)
    done
    rm sshtunnel-keys/ports.txt
    echo -e "$port_http\n$port_https" > sshtunnel-keys/$domain.ports

    # -------------------------------------------------

    # generate the key pair
    local keyfile=sshtunnel-keys/$domain.key
    ssh-keygen -t rsa -f $keyfile -q -N ''

    # put some restrictions on the public key
    local restrictions='command="netstat -an | egrep 'tcp.*:$port_https.*LISTEN'",no-agent-forwarding,no-user-rc,no-X11-forwarding'
    sed -e "s#^#$restrictions #" -i $keyfile.pub

    # update authorized keys
    ds exec /usr/local/sbin/update-authorized-keys.sh

    # -------------------------------------------------

    # add apache2 config files
    cp sites-available/{xmp.conf,$domain.conf}
    sed -i sites-available/$domain.conf \
        -e "/ServerName/ s/example\.org/$domain/" \
        -e "s#http://example\.org#http://$domain:$port_http#" \
        -e "s#https://example\.org#https://$domain:$port_https#"
    ln -s ../sites-available/$domain.conf sites-enabled/

    # reload apache2 config
    ds exec service apache2 reload

    # -------------------------------------------------

    # build the script that can start the tunnel on the client side
    local sshtunnel_start=sshtunnel-keys/$domain.sh
    cp $APP_DIR/misc/sshtunnel-start.sh $sshtunnel_start
    sed -i $sshtunnel_start \
        -e "/^SSH=/ c SSH=$PORT_SSH" \
        -e "/^HTTP=/ c HTTP=$port_http" \
        -e "/^HTTPS=/ c HTTPS=$port_https" \
        -e "/^USER=/ c USER=sshtunnel" \
        -e "/^HOST=/ c HOST=$domain" \
        -e "/-----BEGIN RSA PRIVATE KEY-----/,$ d" 
    cat $keyfile >> $sshtunnel_start
    cat $sshtunnel_start
}
