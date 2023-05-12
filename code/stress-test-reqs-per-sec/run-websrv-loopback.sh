#!/bin/bash
#
# Bind Web server to the loopback interface.
# This provides a measurement baseline.

script_dir=$(dirname "$0")
srv_port=8090
srv="${script_dir}/vsock-websrv/websrv"

if [ "$#" -ne 4 ]
then
	>&2 echo "Usage: $0 NUM_CONCUR_REQS NUM_REQS STDOUT_FILE STDERR_FILE"
	exit 1
fi
num_concur_reqs="$1"
num_reqs="$2"
stdout="$3"
stderr="$4"

"$srv" -port "$srv_port" &
server_pid=$!

baton -i -s "Loopback" -c "$num_concur_reqs" -r "$num_reqs" -u "http://127.0.0.1:$srv_port" >>"$stdout" 2>>"$stderr"

kill "$server_pid"
