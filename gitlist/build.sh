#!/bin/sh

set -e
set -x

ORIG_UID=1001
ORIG_GID=1001

# Configure users
configure_users() {
    # Add a new group
    addgroup -g $ORIG_GID devgroup

    # Add a new user
    adduser                 \
        -D                  \
        -u $ORIG_UID        \
        -G devgroup         \
        -s /bin/sh          \
        devuser
}

# Configure php-fpm
configure_php_fpm() {
    # Configure php
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/php.ini

    # Configure php-fpm:
    #   - No limits on allowed clients
    #   - Do not catch worker outputs
    #   - No error logging
    #   - Do not daemonize
    sed -e 's|^listen\s*=.*$|listen = 127.0.0.1:9000|g'     \
            -e '/allowed_clients/d'                         \
            -e 's/user\s*=\s*nobody/user = devuser/'        \
            -e 's/group\s*=\s*nobody/group = devgroup/'     \
            -e '/catch_workers_output/s/^;//'               \
            -e '/error_log/d'                               \
            -e 's/;daemonize\s*=\s*yes/daemonize = no/g'    \
            -i /etc/php/php-fpm.conf
}

# Configure nginx
configure_nginx() {
    # Set up nginx config
    cat <<EOF > /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}
http {
    include /etc/nginx/mime.types;
    types_hash_max_size 2048;
    server_names_hash_bucket_size 64;

    server {
        listen 80;

        # TODO: send these somewhere
        access_log /dev/stdout combined;
        error_log /dev/stderr error;

        root /var/www/gitlist;
        index index.php;

        location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
        }

        location ~* ^/index.php.*$ {
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            fastcgi_pass 127.0.0.1:9000;
            #fastcgi_pass unix:/var/run/php5-fpm.sock;

            include /etc/nginx/fastcgi_params;
        }

        location / {
            try_files \$uri @gitlist;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
            add_header Vary "Accept-Encoding";
            expires max;
            try_files \$uri @gitlist;
            tcp_nodelay off;
            tcp_nopush on;
        }

#        location ~* \.(git|svn|patch|htaccess|log|route|plist|inc|json|pl|po|sh|ini|sample|kdev4)$ {
#            deny all;
#        }

        location @gitlist {
            rewrite ^/.*$ /index.php;
        }
    }
}
EOF
}

# Configure supervisord
configure_supervisord() {
    # The supervisord configuration
    cat <<EOF > /etc/supervisord.conf
[supervisord]
nodaemon=true

[program:php-fpm]
command=/usr/bin/php-fpm --nodaemonize

[program:nginx]
command=/usr/sbin/nginx -g 'daemon off;'
EOF

    # This is a giant hack.  On startup, we run this script which replaces the
    # user and group IDs of our `devuser` with the values passed in.  This
    # allows that user to then access the repositories that we were given.
    cat <<EOF > /usr/local/bin/init
#!/bin/sh

set -e
set -x

# Get the group/user IDs we're 'impersonating'
export DEV_UID=\${DEV_UID:=$ORIG_UID}
export DEV_GID=\${DEV_GID:=$ORIG_GID}

# Set the user/group of 'devuser' to the given values
sed -i -e "s/:$ORIG_UID:$ORIG_GID:/:\$DEV_UID:\$DEV_GID:/" /etc/passwd
sed -i -e "s/devuser:x:$ORIG_GID:/dockerdev:x:\$DEV_GID:/" /etc/group

# Ensure that the directory nginx expects is present
mkdir -p /tmp/nginx

# Run supervisord
exec /usr/bin/supervisord -c /etc/supervisord.conf
EOF

    chmod +x /usr/local/bin/init
}

# Install GitList
install_gitlist() {
    cd /tmp

    curl -LO https://s3.amazonaws.com/gitlist/gitlist-0.5.0.tar.gz
    gunzip gitlist-0.5.0.tar.gz
    tar xvf gitlist-0.5.0.tar

    mkdir -p /var/www
    mv gitlist /var/www/

    mkdir /var/www/gitlist/cache
    chmod 0777 /var/www/gitlist/cache

    # Configure gitlist
    cat <<EOF > /var/www/gitlist/config.ini
[git]
client = '/usr/bin/git'
default_branch = 'master'
repositories[] = '/repos/'

; hidden[] = '/home/git/repositories/BetaTest'

[app]
debug = false
cache = true
theme = "default"

; If you need to specify custom filetypes for certain extensions, do this here
[filetypes]
; extension = type
; dist = xml

; If you need to set file types as binary or not, do this here
[binary_filetypes]
; extension = true
; svh = false
; map = true

; set the timezone
[date]
; timezone = UTC
; format = 'd/m/Y H:i:s'
EOF

    # Create a dummy repository so we don't get 500 errors
    mkdir /repos
    cd /repos
    git init --bare sentinel
}


doit() {
    configure_users
    configure_php_fpm
    configure_nginx
    configure_supervisord
    install_gitlist
}

doit

# Remove ourselves
rm /build.sh
