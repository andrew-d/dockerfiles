#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR

######################################################################
### INSTALL NGINX

## Update nginx first
apt-get update

## Actually install
apt-get install nginx

## Remove the default Nginx config file
rm -f /etc/nginx/sites-enabled/default


######################################################################
### INSTALL CONFD

curl -L -o /usr/local/bin/confd 'https://github.com/kelseyhightower/confd/releases/download/v0.6.0-alpha3/confd-0.6.0-alpha3-linux-amd64'
chmod +x /usr/local/bin/confd


######################################################################
### INSTALL CONFD WATCH SCRIPT

cp /build/confd-watch /usr/local/bin/confd-watch
chmod +x /usr/local/bin/confd-watch


######################################################################
### CLEANUP

## Clean apt
apt-get clean
rm -rf /var/lib/apt/lists/*

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
