rename_function cmd_create orig_cmd_create
cmd_create() {
    mkdir -p sites-available sites-enabled sshtunnel-keys letsencrypt

    orig_cmd_create \
        -v $(pwd)/letsencrypt:/etc/letsencrypt \
        -v $(pwd)/sshtunnel-keys:/home/sshtunnel/keys \
        -v $(pwd)/sites-available:/etc/apache2/sites-available \
        -v $(pwd)/sites-enabled:/etc/apache2/sites-enabled

    cp $SRC/misc/apache2.conf sites-available/xmp.conf
    touch containers.txt
}
