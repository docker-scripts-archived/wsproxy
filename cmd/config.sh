cmd_config_help() {
    cat <<_EOF
    config
        Configure the guest system inside the container.

_EOF
}

cmd_config() {
    ds runcfg set_prompt
    ds runcfg ssmtp
    ds runcfg apache2

    ds runcfg update-scripts
    ds runcfg letsencrypt
    ds runcfg sshd
    ds runcfg create-user
    ds runcfg apache2
}
