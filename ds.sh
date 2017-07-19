#!/bin/bash

rename_function cmd_start orig_cmd_start
cmd_start() {
    orig_cmd_start
    call cmd_update-etc-hosts
}

rename_function cmd_restart orig_cmd_restart
cmd_restart() {
    orig_cmd_restart
    call cmd_update-etc-hosts
}
