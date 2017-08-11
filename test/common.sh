rm_container_dir() {
    rm -rf $CONTAINERS/wsproxy
}

fix_settings() {
    sed -i settings.sh \
        -e '/^IMAGE=/ c IMAGE=wsproxy-test' \
        -e '/^CONTAINER=/ c CONTAINER=wsproxy-test' \
        -e '/^PORT_SSH=/ c PORT_SSH=2022' \
        -e '/^PORTS=/ c PORTS="8080:80 4043:443"'
}
