#!/usr/bin/env bash

password=$1

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
	--host 5258a974339943bd90b2943d0b628a66.s1.eu.hivemq.cloud \
	--username robenheimer \
	--pw $password \
	--port 8883 \
        -t "/rbnhmr/$(hostname)/commands")
