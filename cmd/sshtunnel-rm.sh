cmd_sshtunnel-rm_help() {
    cat <<_EOF
    sshtunnel-rm <domain>
        Remove the sshtunnel for a domain.

_EOF
}

cmd_sshtunnel-rm() {
    # get the domain
    [[ $# -lt 1 ]] && fail "Usage: $COMMAND <domain>"
    local domain=$1

    # remove ssh keys
    rm -f sshtunnel-keys/$domain.{key,key.pub,sh,ports}

    # update authorized keys
    ds exec /usr/local/sbin/update-authorized-keys.sh

    # remove apache2 config files
    rm -f sites-enabled/$domain.conf
    rm -f sites-available/$domain.conf

    # reload apache2 config
    ds exec service apache2 reload
}
