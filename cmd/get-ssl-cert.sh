cmd_get-ssl-cert_help() {
    cat <<_EOF
    get-ssl-cert <email> <domain>... [-t,--test]
         Get free SSL certificates from letsencrypt.org

_EOF
}

cmd_get-ssl-cert() {
    local usage="Usage: $COMMAND <email> <domain>... [-t,--test]"

    # get the options and arguments
    local test=0
    local opts="$(getopt -o t -l test -- "$@")"
    local err=$?
    eval set -- "$opts"
    while true; do
        case $1 in
            -t|--test) test=1; shift ;;
            --) shift; break ;;
        esac
    done
    [[ $err == 0 ]] || fail $usage

    local email=$1 ; shift
    [[ -n $email ]] || fail $usage

    local domains="$@"
    [[ -n $domains ]] || fail $usage

    # build the certbot args
    local args="certonly  --non-interactive --webroot --keep-until-expiring"
    args+=" --email $email --agree-tos --webroot-path /var/www"
    for domain in $domains; do
        args+=" -d $domain"
    done
    [[ $test == 1 ]] && args+=" --dry-run"

    # run certbot from inside the container
    ds exec certbot $args

    [[ $test == 1 ]] && exit 0

    # update config files
    local container=$(cat containers.txt | cut -d: -f1)
    for domain in $domains; do
        local certdir=/etc/letsencrypt/live/$domain
        # update apache2 config file in wsproxy
        sed -i sites-available/$domain.conf -r \
            -e "s|#?SSLCertificateFile .*|SSLCertificateFile      $certdir/cert.pem|" \
            -e "s|#?SSLCertificateKeyFile .*|SSLCertificateKeyFile   $certdir/privkey.pem|" \
            -e "s|#?SSLCertificateChainFile .*|SSLCertificateChainFile $certdir/chain.pem|"
        # update apache2 config file in the container
        docker exec $container sed -i /etc/apache2/sites-available/$domain.conf -r \
            -e "s|#?SSLCertificateFile .*|SSLCertificateFile      $certdir/cert.pem|" \
            -e "s|#?SSLCertificateKeyFile .*|SSLCertificateKeyFile   $certdir/privkey.pem|" \
            -e "s|#?SSLCertificateChainFile .*|SSLCertificateChainFile $certdir/chain.pem|"
    done

    # reload apache2 config
    ds exec service apache2 reload
}
