#!/bin/sh

set -e              # Shell exits immediately on error
set -x              # Log commands to STDERR
set -u              # Error if expanding an unset variable

status () {
    echo "-----> ${@}" >&2
}

## Show configuration variables (this also causes us to exit if they aren't set).
echo "LDAP_HOST=${LDAP_HOST}"
echo "LDAP_BASE_DN=${LDAP_BASE_DN}"
echo "LDAP_LOGIN_DN=${LDAP_LOGIN_DN}"
echo "LDAP_SERVER_NAME=${LDAP_SERVER_NAME}"

## Configure phpLDAPadmin
if [ ! -e /etc/phpldapadmin/.bootstrapped ]; then
    status "configuring phpLDAPadmin"

    # phpLDAPadmin config
    sed -i "s/'127.0.0.1'/'${LDAP_HOST}'/g" /etc/phpldapadmin/config.php
    sed -i "s/'dc=example,dc=com'/'${LDAP_BASE_DN}'/g" /etc/phpldapadmin/config.php
    sed -i "s/'cn=admin,dc=example,dc=com'/'${LDAP_LOGIN_DN}'/g" /etc/phpldapadmin/config.php
    sed -i "s/'My LDAP Server'/'${LDAP_SERVER_NAME}'/g" /etc/phpldapadmin/config.php

    touch /etc/phpldapadmin/.bootstrapped
else
    status "phpLDAPadmin is already configured"
fi


## Run php-fpm
/usr/sbin/php5-fpm #--nodaemonize

## Run nginx (this runs in the foreground)
exec nginx
