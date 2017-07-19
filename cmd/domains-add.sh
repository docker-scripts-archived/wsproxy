# Add one or more domains to be served by the web proxy.

cmd_domains-add() {
    # get the container and the domains
    [[ $# -lt 2 ]] && fail "Usage: $COMMAND <container> <domain> <domain> ..."
    container=$1
    shift
    domains="$@"

    # remove these domains, if they exist
    ds domains-rm $domains

    # add apache2 config files for each domain
    for domain in $domains
    do
        cp sites-available/{xmp.conf,$domain.conf}
        sed -i sites-available/$domain.conf \
            -e "s/example\.org/$domain/g"
        ln -s ../sites-available/$domain.conf sites-enabled/
    done

    # add the domains on containers.txt
    echo "$container: $domains" >> containers.txt

    # update /etc/hosts
    ds update-etc-hosts

    # reload apache2 config
    ds exec service apache2 reload
}
