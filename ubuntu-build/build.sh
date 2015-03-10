#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR

######################################################################
### INSTALL COMPILERS

apt-get update
apt-get install build-essential autoconf automake


######################################################################
### INSTALL VARIOUS LIBRARIES AND TOOLS

## Common VCSs
apt-get install cvs subversion git-core mercurial

## These libraries are commonly used and are included by default
apt-get install libssl-dev zlib1g-dev

######################################################################
### INSTALL MUSL

export MUSL_VERSION=1.1.6

## Download
cd /tmp
curl -LO http://www.musl-libc.org/releases/musl-${MUSL_VERSION}.tar.gz
tar zxvf musl-${MUSL_VERSION}.tar.gz
cd musl-${MUSL_VERSION}

## Compile and install
./configure
make -j4 && make install
cd /

######################################################################
### CLEANUP

## Clean apt
apt-get clean
rm -rf /var/lib/apt/lists/*

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
