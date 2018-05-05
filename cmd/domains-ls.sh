cmd_domains-ls_help() {
    cat <<_EOF
    domains-ls [<pattern>]
         List the containers and their domains (that match the given pattern).

_EOF
}

cmd_domains-ls() {
    cat containers.txt | grep -e "$1"
}
