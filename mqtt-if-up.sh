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

if [ -n "$DEVICE_IP_IFACE" ]
then
    /usr/local/bin/mqttx pub -t "$1" -h "${2-broker.hivemq.com}" -p "${3-1883}" -m "{\"load\": {\"ip\":\"$IP4_ADDRESS_0\",\"if\":\"$DEVICE_IP_IFACE\"},\"ts\":\"$(date -Iseconds)\"}"
fi
