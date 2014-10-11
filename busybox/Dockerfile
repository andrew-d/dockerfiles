FROM progrium/busybox
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# Default "init" is [a]sh
CMD ["/bin/sh"]
