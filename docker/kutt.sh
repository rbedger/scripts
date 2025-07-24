#!/bin/sh

docker run \
    -d \
    -e JWT_SECRET="zbRpIHhCcBUBE0jhObmPdZSNdKN4MgbGWr5l@t9KMUka9#nhboUhEbOf^%a404pGwT9T1^3h@04#tV6rrQURDtUCoXA5Sk^UQu^e8ozAVvmSM194W$9AQa#XOvZFoZ^e" \
    -p 8081:3000/tcp \
    -e DB_FILENAME=/var/lib/kutt/data \
    -e DEFAULT_DOMAIN=localhost:8081 \
    -e CUSTOM_DOMAIN_USE_HTTPS=false \
    -v ~/kutt-data:/var/lib/kutt \
    --name kutt \
kutt/kutt:latest
