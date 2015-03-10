#!/bin/sh

set -e              # Shell exits immediately on error
set -x              # Log commands to STDERR

######################################################################
### INSTALL DEPENDENCIES

opkg-install curl ca-certificates

# So Go can find the certificates
cat /etc/ssl/certs/*.crt > /etc/ssl/certs/ca-certificates.crt

######################################################################
### INSTALL SYNCTHING

export VERSION=v0.10.25
export RELEASE=syncthing-linux-amd64-${VERSION}

## Download syncthing
curl -L -o /tmp/${RELEASE}.tar.gz \
    https://github.com/syncthing/syncthing/releases/download/${VERSION}/${RELEASE}.tar.gz

## Extract and link syncthing
mkdir -p /usr/local/bin
gunzip /tmp/${RELEASE}.tar.gz
tar xf /tmp/${RELEASE}.tar -C /usr/local
ln -s /usr/local/${RELEASE}/syncthing /usr/local/bin/syncthing


######################################################################
### INSTALL INIT SCRIPT

## Copy the init script
cp /build/init /usr/local/bin/init
chmod +x /usr/local/bin/init

## Copy the run script
cp /build/run-syncthing /usr/local/bin/run-syncthing
chmod +x /usr/local/bin/run-syncthing

## Create the user we run as
adduser                 \
    -D                  \
    -h /home/syncthing  \
    -s /bin/sh          \
    syncthing

## Create a dummy file where the default Sync directory would be - this
## prevents sync from taking place until the repo path is updated manually.
touch /home/syncthing/Sync


######################################################################
### CLEANUP

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
