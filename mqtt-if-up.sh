#!/bin/bash
if [ -n "$DEVICE_IP_IFACE" ]
then
    /usr/local/bin/mqttx pub -t '/rbnhmr/sausalito/ip' -h 'broker.hivemq.com' -p 1883 -m "{\"load\": {\"ip\":\"$IP4_ADDRESS_0\",\"if\":\"$DEVICE_IP_IFACE\"},\"ts\":\"$(date -Iseconds)\"}"
fi
