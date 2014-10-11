#!/bin/sh

######################################################################
### INSTALL STHTTPD

## Ensure the directory exists
mkdir -p /usr/local/bin

## Copy the binary
cp /build/thttpd /usr/local/bin/thttpd
chown root:root /usr/local/bin/thttpd
chmod +x /usr/local/bin/thttpd

## Copy the init script
cp /build/init /usr/local/bin/init
chown root:root /usr/local/bin/init
chmod +x /usr/local/bin/init

######################################################################
### CLEANUP

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
