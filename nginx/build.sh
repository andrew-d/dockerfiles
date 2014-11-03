#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR

######################################################################
### INSTALL NGINX

## Add the PPA for nginx
add-apt-repository -y ppa:nginx/stable

## Update apt first
apt-get update

## Actually install
apt-get install nginx

## Remove the default Nginx config file
rm -f /etc/nginx/sites-enabled/default

## Create default (empty) directories for nginx
mkdir -p /etc/nginx/certs

## Disable daemon mode - we want nginx to start in the foreground.
cat << EOF >> /etc/nginx/nginx.conf

# Added by nginx Dockerfile
daemon off;
EOF

## Fix ownership on directories
chown -R www-data:www-data /var/lib/nginx


######################################################################
### CLEANUP

## Clean apt
apt-get clean
rm -rf /var/lib/apt/lists/*

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
