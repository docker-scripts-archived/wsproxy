cmd_update-etc-hosts_help() {
    cat <<_EOF
    update-etc-hosts
        Update the file /etc/hosts inside the wsproxy container.

_EOF
}

cmd_update-etc-hosts() {
    # get the current copy of /etc/hosts
    docker cp $CONTAINER:/etc/hosts hosts

    # cleanup the previous entries
    sed -i hosts -e '/^### containers/,$ d'

    # add new entries to hosts
    local container domains ip
    echo "### containers" >> hosts
    while read line
    do
        # skip empty lines and comments
        test -z "$line" && continue
        test ${line:0:1} = '#' && continue

        # get the container name and domain
        container=$(echo $line | cut -d: -f1)
        domains=$(echo $line | cut -d: -f2)
        test -z "$container" && continue
        test -z "$domains" && continue

        # get the ip of the container
        ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $container)
        test -z "$ip" && continue

        # add a new entry for this ip
        echo "$ip $domains" >> hosts
        echo "$ip $domains"
    done < containers.txt

    # add new entries for sshtunnel domains
    local domain
    for file in sshtunnel-keys/*.key; do
        domain=$(basename ${file%.key})
        echo "127.0.0.1 $domain" >> hosts
        echo "127.0.0.1 $domain"
    done

    # put the modified copy of /etc/hosts inside the container
    docker cp hosts $CONTAINER:/etc/hosts.new
    ds exec /usr/local/sbin/update-etc-hosts.sh
    rm hosts
}
