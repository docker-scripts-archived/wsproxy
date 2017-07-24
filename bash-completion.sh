# bash completions for the command `ds domains-add`
_ds_domains-rm() {
    local cur=${COMP_WORDS[COMP_CWORD]}   ## $1
    local domains=$(cat containers.txt | cut -d: -f2)
    COMPREPLY=( $(compgen -W "$domains" -- $cur) )
}

# bash completions for the command `ds domains-add`
_ds_domains-add() {
    COMPREPLY=()   # Array variable storing the possible completions.
    local cur=${COMP_WORDS[COMP_CWORD]}     ## $1
    local prev=${COMP_WORDS[COMP_CWORD-1]}  ## $2

    if [[ $COMP_CWORD -eq 2 ]]; then
        local containers=$(docker ps -a --format "{{.Names}}")
        COMPREPLY=( $(compgen -W "$containers" -- $cur) )
    fi
}

# bash completions for the command `ds get-ssl-cert`
_ds_get-ssl-cert() {
    COMPREPLY=()   # Array variable storing the possible completions.
    local cur=${COMP_WORDS[COMP_CWORD]}     ## $1
    local prev=${COMP_WORDS[COMP_CWORD-1]}  ## $2

    if [[ $COMP_CWORD -gt 2 ]]; then
        local domains=$(cat containers.txt | cut -d: -f2)
        COMPREPLY=( $(compgen -W "$domains" -- $cur) )
    fi
}

# bash completions for the command `ds sshtunnel-rm`
_ds_sshtunnel-rm() {
    local cur=${COMP_WORDS[COMP_CWORD]}   ## $1
    local domains=$(ls sshtunnel-keys/*.key | sed -e 's#sshtunnel-keys/##g' -e 's/.key//g')
    COMPREPLY=( $(compgen -W "$domains" -- $cur) )
}
