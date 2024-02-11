#!/usr/bin/env -S pwsh -nop -nol
$ErrorActionPreference = 'Stop';

function log {
    param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string]$msg
    )

    write-output ('[{0}] :: {1}' -f (get-date), $msg)
}

try {
    log 'Starting!'

    &cloudflare-ddns @(
        "--proxied",
        "rbedger@gmail.com",
        $args[0],
        "robenheimer.com"
    ) | log
} catch {
    log $_
    throw $_
} finally {
    log 'Finished!'
}

