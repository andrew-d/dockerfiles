FROM ubuntu:14.04.1
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# Default "init" is bash
CMD ["/bin/bash"]
