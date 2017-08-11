source $(dirname $BASH_SOURCE)/common.sh

description 'Test make'

test_case 'ds make' '
    ds pull wsproxy &&
    rm_container_dir &&
    ds init wsproxy @wsproxy &&
    cd $CONTAINERS/wsproxy &&
    fix_settings &&
    ds make &&
    tail logs/nohup-*.out | grep "Successfully built" &&
    docker images --format "{{.Repository}}" | grep wsproxy-test &&
    docker ps -a --format "{{.Names}}" | grep wsproxy-test &&
    ds stop
'
