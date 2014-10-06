#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR

######################################################################
### BUILD

export STHTTPD_VERSION=2.27.0

## Download
cd /tmp
curl -L -o sthttpd.tar.gz http://opensource.dyc.edu/pub/sthttpd/sthttpd-${STHTTPD_VERSION}.tar.gz
tar zxvf sthttpd.tar.gz
cd sthttpd*

## Build as static binary using musl
## Note: the WEBDIR variable is described as:
##      WEBDIR      The document root directory of your web page
./configure CC=/usr/local/musl/bin/musl-gcc CFLAGS="-static" WEBDIR="/data"
make -j4

## Copy output
cp src/thttpd /data/
