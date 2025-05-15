#!/bin/bash

: <<'DOC'
   _______________                        |*\_/*|________
  |  ___________  |     .-.     .-.      ||_/-\_|______  |
  | |           | |    .****. .****.     | |           | |
  | |   0   0   | |    .*****.*****.     | |   0   0   | |
  | |     -     | |     .*********.      | |     -     | |
  | |   \___/   | |      .*******.       | |   \___/   | |
  | |___     ___| |       .*****.        | |___________| |
  |_____|\_/|_____|        .***.         |_______________|
    _|__|/ \|_|_.............*.............._|________|_
   / ********** \                          / ********** \
 /  ************  \                      /  ************  \
--------------------                    --------------------

DOC

if [ $# -lt 1 ]
then
    cat << EOT
    🪄 ifconfig -> mqtt 🔮

    publishes ip address, gateway, and interface information to mqtt

    this script is intended to be called via NetworkManager, thus the following env is expected:
        - IPV4_ADDRESS_0
        - DEVICE_IP_IFACE

    to call it automatically upon interface up, create a script in /etc/NetworkManager/dispatcher.d

    USAGE:
        mqtt-if-up.sh <topic> <password> [<broker> <port> <username>]

    PARAMETERS:
        topic:  mqtt topic to publish to
        broker: mqtt broker address (default broker.hivemq.com)
        port:   mqtt broker port (default 1883)
EOT

    exit 1
fi

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/var/log/mqtt-if-up.log 2>&1

iface="${DEVICE_IP_IFACE-wlan0}"
topic="${1}/$iface"
password="$2"
broker="${3-5258a974339943bd90b2943d0b628a66.s1.eu.hivemq.cloud}"
port="${4-8883}"
username="${5-robenheimer}"

json=$(jq -ncr \
    --arg ip "${IP4_ADDRESS_0-none}" \
    --arg ts "$(date -Iseconds)" \
    '$ARGS.named')

if [[ -n "$iface" && "$iface" != "lo" ]]
then
    echo " "
    echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
    echo $(date)
    echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
    echo "iface: $iface"
    echo "broker: $broker"
    echo "port: $port"
    echo "topic: $topic"
    echo "username: $username"

    echo "message: $json"

    /usr/bin/env mosquitto_pub \
        -t "$topic" \
        -h "$broker" \
        -p "$port" \
        -m "$json" \
        -u "$username" \
        -P "$password"
    echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
fi
