FROM andrewd/ubuntu
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# This Dockerfile creates a Ubuntu image that has common tools for compiling/
# building applications installed.

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# The data directory can be used to transfer data and built artifacts.
VOLUME ["/data"]

# By default, run Bash
CMD ["/bin/bash"]
