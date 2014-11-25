FROM andrewd/ubuntu
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Expects to be run as:
#     docker run -e LDAP_HOST=IP_ADDRESS
#                -e LDAP_BASE_DN=dc=mycorp,dc=com
#                -e LDAP_LOGIN_DN=cn=admin,dc=mycorp,dc=com
#                -e LDAP_SERVER_NAME="My Mega Corporation"
#                -d andrewd/phpldapadmin

# Default configuration (should be overridden)
ENV LDAP_HOST 127.0.0.1
ENV LDAP_BASE_DN dc=example,dc=com
ENV LDAP_LOGIN_DN cn=admin,dc=example,dc=com
ENV LDAP_SERVER_NAME docker.io phpLDAPadmin

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# Expose the port that nginx is running on
EXPOSE 80

# Use the installed init script
CMD ["/usr/local/bin/init"]
