#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR

######################################################################
### INSTALL OPENLDAP

## Update apt first
apt-get update

## Actually install
apt-get install slapd


######################################################################
### INSTALL INIT SCRIPT

## Copy the init script
cp /build/init /usr/local/bin/init
chmod +x /usr/local/bin/init


######################################################################
### CLEANUP

## Clean apt
apt-get clean
rm -rf /var/lib/apt/lists/*

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
