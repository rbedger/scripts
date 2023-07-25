#!/bin/bash

echo "proxy_pass certbot;" > /etc/nginx/whichServer.conf
systemctl reload nginx

certbot renew

echo "proxy_pass ssh;" > /etc/nginx/whichServer.conf
systemctl reload nginx

