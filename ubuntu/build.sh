#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR

######################################################################
### PREPARE THE SYSTEM

## Disable dpkg fsync to make building faster
echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup

## Various apt configs
##  - Don't install recommended or suggested packages
##  - Always run as if passing -yy
echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01buildconfig
echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01buildconfig
echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01buildconfig
echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01buildconfig

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe and Multiverse.
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list
apt-get update

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

## Upgrade all packages.
apt-get dist-upgrade

## Fix locale.
apt-get install language-pack-en
locale-gen en_US

######################################################################
### INSTALL COMMON UTILITIES

apt-get install \
    ca-certificates \
    curl \
    git-core \
    less \
    nano \
    psmisc \
    python-software-properties \
    vim

cp /build/setuser /sbin/setuser && chmod +x /sbin/setuser

######################################################################
### CLEANUP

## Remove useless cron entries (checks for lost+found and scans mtab)
rm -f /etc/cron.daily/standard

## Remove our dpkg hack (from above)
rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

## Clean apt
apt-get clean
rm -rf /var/lib/apt/lists/*

## Remove temp files
rm -rf /tmp/* /var/tmp/*

## Finally, remove the entire /build directory (and ourselves)
rm -rf /build
