#!/bin/bash

SUDO=''

if (( $EUID != 0 )); then
    if [ -x "$(command -v doas)" ];   then SUDO='doas'
    elif [ -x "$(command -v sudo)" ]; then SUDO='sudo'
    else su -;
    fi
fi


if [[ -z $(which git) ]]; then
    packagesNeeded='git'

    if [ -x "$(command -v apk)" ];       then $SUDO apk add --no-cache $packagesNeeded
    elif [ -x "$(command -v pacman)" ];  then $SUDO pacman -S --noconfirm $packagesNeeded
    elif [ -x "$(command -v apt-get)" ]; then $SUDO apt-get install -y $packagesNeeded
    elif [ -x "$(command -v dnf)" ];     then $SUDO dnf install $packagesNeeded
    elif [ -x "$(command -v zypper)" ];  then $SUDO zypper install $packagesNeeded
    else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2;
    fi
fi

git clone https://github.com/biocoderh/turbo-boost.git
cd turbo-boost

$SUDO chmod +x turbo-boost.sh install.sh uninstall.sh
$SUDO ./install.sh

cd ..
rm -rdf turbo-boost


if [[ -z "$SUDO" ]]; then
    exit
fi
