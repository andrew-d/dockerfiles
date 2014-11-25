#!/bin/bash

set -e              # Shell exits immediately on error
set -o pipefail     # Exit if any stage in a pipeline fails
set -x              # Log commands to STDERR


######################################################################
### PREPARATION

## Add the PPA for nginx
add-apt-repository -y ppa:nginx/stable

## Update apt
apt-get update


######################################################################
### INSTALL NGINX

## Actually install
apt-get install nginx

## Remove the default Nginx config file
rm -f /etc/nginx/sites-enabled/default

## Disable daemon mode - we want nginx to start in the foreground.
cat << EOF >> /etc/nginx/nginx.conf

# Added by phpLDAPadmin Dockerfile
daemon off;
EOF

## Fix ownership on directories
chown -R www-data:www-data /var/lib/nginx

######################################################################
### INSTALL PHP

## Actually install
apt-get install php5-fpm php5-cli php5-ldap php-apc php5-mysql

## Set configuration settings
sed -i -e "s/expose_php = On/expose_php = Off/g" /etc/php5/fpm/php.ini
sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
sed -i -e "s/;listen.owner = www-data/listen.owner = www-data/g" /etc/php5/fpm/pool.d/www.conf
sed -i -e "s/;listen.group = www-data/listen.group = www-data/g" /etc/php5/fpm/pool.d/www.conf


######################################################################
### INSTALL PHPLDAPADMIN

## Actually install
apt-get install phpldapadmin

## Fix the bug with password_hash
### See http://stackoverflow.com/questions/20673186/getting-error-for-setting-password-feild-when-creating-generic-user-account-phpl
sed -i "s/'password_hash'/'password_hash_custom'/" /usr/share/phpldapadmin/lib/TemplateRender.php

## Hide template warnings
sed -i "s:// \$config->custom->appearance\['hide_template_warning'\] = false;:\$config->custom->appearance\[\'hide_template_warning\'\] = true;:g" /etc/phpldapadmin/config.php

## Install nginx site
cat <<EOF > /etc/nginx/sites-available/phpldapadmin
server {
    listen 80;
    listen [::]:80;

    server_name localhost;

    root /usr/share/phpldapadmin/htdocs;
    index index.html index.htm index.php;

    ## PHP config
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        # NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $$document_root$$fastcgi_script_name;
        fastcgi_index index.php;

        include fastcgi_params;
    }
}
EOF

## Enable site
ln -s /etc/nginx/sites-available/phpldapadmin /etc/nginx/sites-enabled/phpldapadmin

## Set up init script
cp /build/init.sh /usr/local/bin/init
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
