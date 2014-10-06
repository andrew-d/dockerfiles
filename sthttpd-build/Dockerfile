FROM andrewd/ubuntu-build
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# This container builds a statically-linked sthttpd[0] binary and places it in
# /data/thttpd when the build is finished.  You can run it like so:
#   docker run --rm -v `pwd`:/data andrewd/sthttpd-build
#
# [0] http://blogs.gentoo.org/blueness/2014/10/03/sthttpd-a-very-tiny-and-very-fast-http-server-with-a-mature-codebase/

# Our build script
ADD ./build.sh /build.sh

# The build output
VOLUME ["/data"]

# Run the build
CMD ["/build.sh"]
