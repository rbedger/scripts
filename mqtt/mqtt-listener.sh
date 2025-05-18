#!/bin/bash

export HOME=/root

while read topic
do
    echo $topic

    cmd=$(jq -r .cmd <<< $topic)

    case $cmd in
        shutdown)
            echo "shutting down"
            shutdown 0
            ;;

        reboot)
            echo "rebooting"
            reboot
            ;;
    esac
done < <(mosquitto_sub \
        -t "/rbnhmr/$(hostname)/commands")
