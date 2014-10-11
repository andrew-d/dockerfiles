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

## Disable various things that we don't want:
### 1. Directory indexes
sed -i -e 's/^#define GENERATE_INDEXES$/\/* #define GENERATE_INDEXES *\//' src/thttpd.h

### 2. Server version
sed -i -e 's/^#define SHOW_SERVER_VERSION$/\/* #define SHOW_SERVER_VERSION *\//' src/thttpd.h

### 3. Verbose information in error pages
sed -i -e 's/^#define EXPLICIT_ERROR_PAGES$/\/* #define EXPLICIT_ERROR_PAGES *\//' src/thttpd.h

### 4. Names of index files (this removes e.g. index.cgi)
sed -i -e 's/^#define INDEX_NAMES\s.*$/#define INDEX_NAMES "index.html", "index.htm"/' src/thttpd.h

## Build as static binary using musl
## Variables:
##      WEBDIR      The document root directory of your web page
./configure CC=/usr/local/musl/bin/musl-gcc CFLAGS="-static" WEBDIR="/data"
make -j4

## Copy output
cp src/thttpd /data/
