FROM andrewd/ubuntu
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# This Dockerfile expects the following volumes:
#   - /etc/nginx/sites-enabled          Containing the sites that should be enabled
#   - /etc/nginx/certs                  Location for SSL certs
#   - /etc/nginx/conf.d                 Other configuration for nginx
#   - /var/log/nginx                    Log files
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

# Expose the ports
EXPOSE 80 443

CMD ["nginx"]
