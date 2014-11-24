FROM andrewd/ubuntu
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Expects to be run as:
#     docker run -v /data/ldap/db:/var/lib/ldap \
#                -v /data/ldap/log:/var/log \
#                -e LDAP_DOMAIN=mycorp.com \
#                -e LDAP_ORGANISATION="My Mega Corporation" \
#                -e LDAP_ROOTPASS=s3cr3tpassw0rd \
#                -d andrewd/slapd

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# Default configuration - can be overriden at command line
ENV LDAP_ROOTPASS toor
ENV LDAP_ORGANISATION Acme Widgets Inc.
ENV LDAP_DOMAIN example.com

# slapd's port
EXPOSE 389

# The slapd data directory is a volume
VOLUME ["/var/lib/ldap"]

# Run slapd
CMD ["/usr/local/bin/init"]
