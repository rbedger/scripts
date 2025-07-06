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

if [ "$1" = "-h" ]
then
    cat << EOT
    🪄 ifconfig -> mqtt 🔮

    publishes ip address, gateway, and interface information to mqtt

    USAGE:
      mqtt-if-up.sh [DEVICE_IP_IFACE] [IP4_ADDRESS_0]

    PARAMETERS:
      DEVICE_IP_IFACE:  the interface name. this can come from arg1 or as env
      IP4_ADDRESS_0:    the IPv4 address. this can come from arg2 or as env

    to call it automatically upon interface up, create a script in /etc/NetworkManager/dispatcher.d
EOT

    exit 1
fi

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/var/log/mqtt-if-up.log 2>&1

iface=${DEVICE_IP_IFACE-"$0"}
topic="/rbnhmr/$(hostname)/ip/$iface"

ip=${IP4_ADDRESS_0-"$1"}
if [ -z $ip ];then
  ip=$(ifconfig "$iface" | grep inet | cut -d" " -f2)
fi

json=$(jq -ncr \
    --arg ip "$ip" \
    --arg ts "$(date -Iseconds)" \
    '$ARGS.named')

echo " "
echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo $(date)
echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo "iface: $iface"

if [[ -n "$iface" && "$iface" != "lo" ]]
then
    echo "topic: $topic"
    echo "message: $json"

    export HOME=/root

    /usr/bin/env mosquitto_pub \
        -t "$topic" \
        -m "$json"
else
    echo "iface was empty or loopback, quitting"
fi

echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
