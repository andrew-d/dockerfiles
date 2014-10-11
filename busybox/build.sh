#!/bin/sh

######################################################################
### PREPARE THE SYSTEM

## Update opkg
opkg-cl update

## Move our functions.sh into place
## NOTE: from https://dev.openwrt.org/browser/trunk/package/base-files/files/lib/functions.sh
cp /build/functions.sh /lib/functions.sh

######################################################################
### INSTALL COMMON UTILITIES

opkg-install ca-certificates curl

## Make cURL work with SSL
echo 'capath = "/etc/ssl/certs"' > ~/.curlrc

######################################################################
### CLEANUP

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
