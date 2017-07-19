cmd_reload() {
    # reload apache2 config
    ds exec service apache2 reload
    # update authorized keys
    ds exec /usr/local/sbin/update-authorized-keys.sh
}
