FROM andrewd/ubuntu
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# This Dockerfile expects the following volumes:
#   - /etc/confd/           Containing the file: /etc/confd/conf.d/nginx.toml
#   - /etc/nginx/ssl/       Containing the files: /etc/nginx/ssl/wildcard.{crt,key}
# TODO: should we mount /var/log/nginx so log files don't fill up the container?
VOLUME ["/etc/confd", "/etc/nginx/ssl"]

# This script kicks off confd and nginx
CMD ["/usr/local/bin/confd-watch"]
