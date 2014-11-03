#!/bin/sh

######################################################################
### PREPARE THE SYSTEM

## Update opkg
opkg-cl update

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
