#!/usr/bin/env bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/var/log/getRAM.log 2>&1

topic="/rbnhmr/$(hostname)/RAM"
usage=$(free -m | grep Mem | awk '{print ($3/$2)*100}')

echo " "
echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo $(date)
echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo "topic: $topic"
echo "RAM Usage: $usage"

/usr/bin/env mosquitto_pub \
    -t "$topic" \
    -m "$usage"

echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
