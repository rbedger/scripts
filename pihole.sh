#!/bin/sh
#
# pulls latest docker image for pihole/pihole
# starts a docker container for pihole with 53, 80, and 443 port-forwarded
# uses docker volumes to support image updates
# only post-configuration is to set DNS server to 127.0.0.1
#
sudo docker pull pihole/pihole:latest
sudo docker run \
    --name pihole \
    -p 53:53/tcp \
    -p 53:53/udp \
    -p 80:80/tcp \
    -p 443:443/tcp \
    -e TZ=America/New_York \
    -e FTLCONF_webserver_api_password="correct horse battery staple" \
    -e FTLCONF_dns_listeningMode=all \
    -v ~/etc-pihole:/etc/pihole \
    -v ~/etc-dnsmasq.d:/etc/dnsmasq.d \
    -d \
    --cap-add NET_ADMIN \
    --restart unless-stopped \
pihole/pihole:latest
