#! /usr/bin/env pwsh -nop -nol
param(
    [Parameter(Mandatory=$true)]
    [System.Int32]$degree,

    [Parameter(Mandatory=$false)]
    [String]$displayName = 'ViewSonic',

    [Parameter(Mandatory=$false)]
    [String]$displayId
)

gcm displayplacer `
    | select `
        -ExpandProperty Path `
        -OutVariable displayplacer

if (!$displayId) {
    $known = gc "$PSScriptRoot/knownDisplays.yaml" | ConvertFrom-Yaml

    $displayId = $known.$displayName;
    if (!$displayId) {
        $known | ConvertTo-Yaml | Write-Host
        throw "Could not match display name $displayName"
    }
}

Invoke-Expression -Command "displayplacer `"id:$displayId degree:$degree`""
