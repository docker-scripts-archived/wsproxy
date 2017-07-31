# bash completions for the command `ds domains-add`
_ds_domains-add() {
    local containers=$(docker ps -a --format "{{.Names}}")
    COMPREPLY=( $(compgen -W "$containers" -- $1) )
}

# bash completions for the command `ds domains-rm`
_ds_domains-rm() {
    local domains=$(cat $(_ds_container_dir)/containers.txt | cut -d: -f2)
    COMPREPLY=( $(compgen -W "$domains" -- $1) )
}

# bash completions for the command `ds get-ssl-cert`
_ds_get-ssl-cert() {
    local domains=$(cat $(_ds_container_dir)/containers.txt | cut -d: -f2)
    COMPREPLY=( $(compgen -W "$domains" -- $1) )
}

# bash completions for the command `ds sshtunnel-rm`
_ds_sshtunnel-rm() {
    local domains=$(ls sshtunnel-keys/*.key | sed -e 's#sshtunnel-keys/##g' -e 's/.key//g')
    COMPREPLY=( $(compgen -W "$domains" -- $1) )
}
