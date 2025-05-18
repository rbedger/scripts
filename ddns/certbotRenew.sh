#!/bin/bash

# certbot must renew on port 80, but wut if ur using port 80?
# one solution is to utilize config file imports, toggling the proxy_pass directive.
#
# replaces the contents of a dynamically loaded nginx config file,
# asks certbot to renew the certificate, and replaces the contents of the file

echo "proxy_pass certbot;" > /etc/nginx/whichServer.conf
systemctl reload nginx

certbot renew

echo "proxy_pass ssh;" > /etc/nginx/whichServer.conf
systemctl reload nginx

