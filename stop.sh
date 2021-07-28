#!/bin/bash

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    /var/minecraft/mcrcon -H localhost -P 8308 -p lDGg@yz@TNC stop
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

#Execute a command
"${@}" &

#Wait
wait $!