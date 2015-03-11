FROM gliderlabs/alpine:3.1
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Install supervisord, nginx, php-fpm and GitList dependencies
RUN apk-install                     \
        ca-certificates             \
        curl                        \
        git                         \
        nginx                       \
        php-ctype                   \
        php-fpm                     \
        supervisor

# Run setup / install script
ADD ./build.sh /build.sh
RUN /build.sh

CMD ["/usr/local/bin/init"]
