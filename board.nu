# This nushell module allows files to be pushed and pulled from a connected Gateway.
#
# Prepare:
#
#           use board.nu 
#
# Push files from the rootfs overlay directory to the board:
#
#           board push
#
# Pull overlay files from board to a local directory: 
#
#           board pull
#
# Run a command on the board
#
#           board do _command_ ..._args_

# The footfs overlay relative to the project directory
export const rootfs = path self | path dirname | path join "board/cuprous/raspberrypi5_cuprous_gw/rootfs_overlay"

# The usual ssh address of the board
export const host = "root@172.27.1.1"

# Pull the rootfs overlay files from the board
export def pull [destin?] {
    files_relative_to $rootfs | fetch_each $host $destin
}

# Push the rootfs overlay files to the board
export def push [source: path = $rootfs] {
    tar -C $source -c . | ssh $host tar -C / --owner=0 --group=0 -x
}

# Run a command on the board
export def --wrapped do [command ...args] {
    ssh_quote $host $command ...$args
}

# Returns all relative paths under the given base directory 
def files_relative_to [base] {
    let base = $base | path expand
    glob --no-dir  ($base | path join **) | path relative-to $base
}

# Fetch each path on the input from a host to a destination directory
def fetch_each [host destin?] {
    let destin = if $destin == null { $host } else { $destin }
    prohibit ($destin | path exists) "destination already exists"
    mkdir $destin
    ssh_quote $host tar -C / -c ...$in | tar -C $destin -x 
}

# Run a command remotely on host with given arguments.
# Each argument can contain spaces (but not quote characters).
def --wrapped ssh_quote [host command ...args] {
    let quoted = if $args == [] {
        $command
    } else {
        $command + ' "' + ($args | str join '" "') + '"'
    }
    ssh $host $quoted
}

# Error if condition holds
def prohibit [cond: bool text: string] {
    if $cond { error make -u { msg: $text} }
}

export def "ping clc" [] {
  (curl -v 
    -X PUT 
    --data '{"bind_addr":"0.0.0.0:8081","connection":"wss://prd.wevolt-ev.com:443","call_timeout":5,"ping_interval":20,"retry_back_off_repeat_times":3,"retry_back_off_random_range":10,"retry_back_off_wait_minimum":3}' 
    -H'Content-Type: application/json' 
    http://172.27.1.1/api/v1/csmses/0 
  )
}

export def "ping gw" [] {
  (curl -v 
    -H'Content-Type: application/json' 
    http://172.27.1.1:8080/ 
  )
}
