FROM andrewd/busybox
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# Put data files to be served here.
VOLUME ["/data"]

CMD ["/usr/local/bin/init"]
