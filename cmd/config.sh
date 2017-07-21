cmd_config() {
    cmd_start
    sleep 3

    # run config scripts
    local config="
        set_prompt
        ssmtp
        apache2

        update-scripts
        letsencrypt
        sshd
        create-user
        apache2
    "
    for cfg in $config; do
        ds runcfg $cfg
    done

    cmd_restart
}
