cmd_domains-add_help() {
    cat <<_EOF
    domains-add <container> <domain> <domain> ...
         Add one or more domains to the configuration of the web proxy.

_EOF
}

cmd_domains-add() {
    # get the container and the domains
    [[ $# -lt 2 ]] && fail "Usage: $COMMAND <container> <domain> <domain> ..."
    local container=$1
    shift
    local domains="$@"

    # remove these domains, if they exist
    ds domains-rm $domains

    # add apache2 config files for each domain
    for domain in $domains; do
        cp sites-available/{xmp.conf,$domain.conf}
        sed -i sites-available/$domain.conf \
            -e "s/example\.org/$domain/g"
        ln -s ../sites-available/$domain.conf sites-enabled/
    done

    # add the domains on containers.txt
    grep -q -e "^$container:" containers.txt \
        || echo "$container:" >> containers.txt
    for domain in $domains; do
        sed -i containers.txt \
            -e "/$container:/ s/\$/ $domain/"
    done

    # reload apache2 config
    ds exec service apache2 reload
}
