#!/usr/bin/env -S pwsh -nop -nol
$ErrorActionPreference = 'Stop';

function log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$msg
    )

    write-output ('[{0}] :: {1}' -f (get-date), $msg)
}


try {
    push-location /etc/nginx/site-sources/home

    log 'Starting!'

    git pull
    npm install
    npm run build

    log 'Finished!'
} catch {
    log $_
    throw $_
} finally {
    pop-location
}
