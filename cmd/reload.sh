cmd_reload_help() {
    cat <<_EOF
    reload
        Update the configuration of apache2 and ssh.

_EOF
}

cmd_reload() {
    # reload apache2 config
    ds exec service apache2 reload
    # update authorized keys
    ds exec /usr/local/sbin/update-authorized-keys.sh
}
