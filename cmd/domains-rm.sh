cmd_domains-rm_help() {
    cat <<_EOF
    domains-rm <domain> <domain> ...
         Remove one or more domains from the configuration of the web proxy.

_EOF
}

cmd_domains-rm() {
    # get the domains
    [[ $# -lt 1 ]] && fail "Usage: $COMMAND <domain> <domain> ..."
    local domains="$@"

    # remove apache2 config files for each domain
    for domain in $domains
    do
        rm -f sites-enabled/$domain.conf
        rm -f sites-available/$domain.conf
    done

    # remove the domains from containers.txt
    touch containers.txt
    for domain in $domains
    do
        sed -i containers.txt -e "/ $domain/d"
    done

    # reload apache2 config
    ds exec service apache2 reload
}
