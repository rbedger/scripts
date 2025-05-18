#!/usr/bin/env bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/var/log/getCPU.log 2>&1

topic="/rbnhmr/$(hostname)/CPU"
usage="$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"

echo " "
echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo $(date)
echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo "topic: $topic"
echo "CPU Usage: $usage"

/usr/bin/env mosquitto_pub \
    -t "$topic" \
    -m "$usage"

echo "=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
