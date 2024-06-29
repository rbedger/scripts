#!/bin/bash

function pi-bak-rhr {
    if [ -z $1 ]
    then
        cat << EOT
        backup.sh <device> [<outFile>(./piBak.dd.gz)]
EOT
    else
        sudo dd if="$1" bs=32M | gzip -c > "${2-./piBak.dd.gz}"
    fi;
}
alias pibak=pi-bak-rhr

function pi-res-rhr {
    gzipSource="$1"
    destDevice="$2"
    blockSize="${3-32M}"

    sudo gzip -cd "$gzipSource" | dd of="$destDevice" bs="$blockSize"
}
alias pires=pi-res-rhr
