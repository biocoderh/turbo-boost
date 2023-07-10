#!/bin/bash

SUDO=''

if (( $EUID != 0 )); then
    if [ -x "$(command -v doas)" ];   then SUDO='doas'
    elif [ -x "$(command -v sudo)" ]; then SUDO='sudo'
    else su -;
    fi
fi


if [[ -z $(which rdmsr) ]]; then
    packagesNeeded='msr-tools'

    if [ -x "$(command -v apk)" ];       then $SUDO apk add --no-cache $packagesNeeded
    elif [ -x "$(command -v pacman)" ];  then $SUDO pacman -S --noconfirm $packagesNeeded
    elif [ -x "$(command -v apt-get)" ]; then $SUDO apt-get install -y $packagesNeeded
    elif [ -x "$(command -v dnf)" ];     then $SUDO dnf install $packagesNeeded
    elif [ -x "$(command -v zypper)" ];  then $SUDO zypper install $packagesNeeded
    else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2;
    fi
fi

$SUDO chmod +x turbo-boost.sh
$SUDO cp turbo-boost.sh /usr/local/bin/turbo-boost.sh

if [[ -d /run/systemd/system ]]; then
    $SUDO cp disable-turbo-boost.service /etc/systemd/system/disable-turbo-boost.service
    $SUDO systemctl start disable-turbo-boost.service
    $SUDO systemctl enable disable-turbo-boost.service
fi


if [[ -z "$SUDO" ]]; then
    exit
fi
