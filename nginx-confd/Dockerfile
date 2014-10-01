FROM andrewd/ubuntu
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# This Dockerfile expects the volume /etc/confd/ to be mounted
# containing the file: /etc/confd/conf.d/nginx.toml
VOLUME ["/etc/confd"]

# This script kicks off confd and nginx
CMD ["/usr/local/bin/confd-watch"]
