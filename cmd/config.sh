cmd_config_help() {
    cat <<_EOF
    config
        Configure the guest system inside the container.

_EOF
}

cmd_config() {
    ds inject ubuntu-fixes.sh
    ds inject set_prompt.sh
    ds inject ssmtp.sh
    ds inject apache2.sh

    ds inject update-scripts.sh
    ds inject letsencrypt.sh
    ds inject sshd.sh
    ds inject create-user.sh
    ds inject apache2.sh
}
