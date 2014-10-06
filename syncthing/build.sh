#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR

######################################################################
### INSTALL SYNCTHING

export VERSION=v0.9.19
export RELEASE=syncthing-linux-amd64-${VERSION}

## Download syncthing
curl -L -o /tmp/${RELEASE}.tar.gz \
    https://github.com/calmh/syncthing/releases/download/${VERSION}/${RELEASE}.tar.gz

## Extract and link syncthing
tar zxf /tmp/${RELEASE}.tar.gz -C /usr/local
ln -s /usr/local/${RELEASE}/syncthing /usr/local/bin/syncthing


######################################################################
### INSTALL INIT SCRIPT

## Copy the init script
cp /build/init /usr/local/bin/init
chmod +x /usr/local/bin/init

## Create the user we run as
useradd -m syncthing

## Create a dummy file where the default Sync directory would be - this
## prevents sync from taking place until the repo path is updated manually.
touch /home/syncthing/Sync


######################################################################
### CLEANUP

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
