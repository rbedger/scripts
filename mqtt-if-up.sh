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
        mqtt-if-up.sh <topic> [<broker> <port>]

    PARAMETERS:
        topic:  mqtt topic to publish to
        broker: mqtt broker address (default broker.hivemq.com)
        port:   mqtt broker port (default 1883)
EOT

    return
fi

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/var/log/mqtt-if-up.log 2>&1

broker="${2-broker.hivemq.com}"
port="${3-1883}"

if [ -n "$DEVICE_IP_IFACE" ]
then
    echo "ip: $IP4_ADDRESS_0"
    echo "if: $DEVICE_IP_IFACE"
    echo "topic: $1"
    echo "broker: $broker"
    echo "port: $port"

    /usr/bin/env mqttx pub -t "$1" -h "$broker" -p "$port" -m "{\"load\": {\"ip\":\"$IP4_ADDRESS_0\",\"if\":\"$DEVICE_IP_IFACE\"},\"ts\":\"$(date -Iseconds)\"}"
fi
