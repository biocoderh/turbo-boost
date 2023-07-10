#!/bin/bash

SUDO=''

if (( $EUID != 0 )); then
    if [ -x "$(command -v doas)" ];   then SUDO='doas'
    elif [ -x "$(command -v sudo)" ]; then SUDO='sudo'
    else su -;
    fi
fi


if [[ -d /run/systemd/system ]]; then
    $SUDO systemctl disable disable-turbo-boost.service
    $SUDO systemctl stop disable-turbo-boost.service
    $SUDO rm /etc/systemd/system/disable-turbo-boost.service
fi

$SUDO rm /usr/local/bin/turbo-boost.sh


if [[ -z "$SUDO" ]]; then
    exit
fi
