cmd_create_help() {
    cat <<_EOF
    create
        Create the wsproxy container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    mkdir -p sites-available sites-enabled sshtunnel-keys letsencrypt

    orig_cmd_create \
        -v $(pwd)/letsencrypt:/etc/letsencrypt \
        -v $(pwd)/sshtunnel-keys:/home/sshtunnel/keys \
        -v $(pwd)/sites-available:/etc/apache2/sites-available \
        -v $(pwd)/sites-enabled:/etc/apache2/sites-enabled

    cp $APP_DIR/misc/apache2.conf sites-available/xmp.conf
    touch containers.txt

    _create_cmd_wsproxy
}

_create_cmd_wsproxy() {
    mkdir -p $DSDIR/cmd/
    local cmdfile=$DSDIR/cmd/$CONTAINER.sh
    cat <<-__EOF__ > $cmdfile
cmd_${CONTAINER}_help() {
    cat <<_EOF
    $CONTAINER [add | rm | ssl-cert [-t]]
        Manage the domain '\$DOMAIN' of the container.

_EOF
}

cmd_${CONTAINER}() {
    case \$1 in
        add)       ds @$CONTAINER domains-add  \$CONTAINER \$DOMAIN  ;;
        rm)        ds @$CONTAINER domains-rm   \$DOMAIN  ;;
        ssl-cert)  ds @$CONTAINER get-ssl-cert \$GMAIL_ADDRESS \$DOMAIN \$2  ;;
        *)         echo -e "Usage:\\n\$(cmd_${CONTAINER}_help)" ; exit ;;
    esac
}
__EOF__
}
