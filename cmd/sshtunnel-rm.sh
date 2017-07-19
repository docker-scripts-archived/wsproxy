# Remove the sshtunnel for a domain.

cmd_sshtunnel-rm() {
    # get the domain
    [[ $# -lt 1 ]] && fail "Usage: $COMMAND <domain>"
    domain=$1

    # remove ssh keys
    rm -f sshtunnel-keys/$domain.{key,key.pub,sh,ports}

    # update authorized keys
    ds exec /usr/local/sbin/update-authorized-keys.sh

    # remove apache2 config files
    rm -f sites-enabled/$domain.conf
    rm -f sites-available/$domain.conf

    # update /etc/hosts
    ds update-etc-hosts

    # reload apache2 config
    ds exec service apache2 reload
}
