FROM andrewd/ubuntu
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Expects to be run as:
#    docker run -d --name syncthing \
#              -p 8080:8080 -p 22000:22000 -p 21025:21025/udp \
#              -v /path/to/config:/home/syncthing/.config/syncthing \
#              -v /path/to/repos:/home/syncthing/repos \
#              andrewd/syncthing
#
# Note that you must configure Syncthing to place repos in
# /home/syncthing/repos, or they will not persist between container starts.
# A dummy file has been placed where the default Sync directory would be, to
# ensure that synchronization will not work until a proper path has been
# configured.

# Add our files to /build
RUN mkdir /build
ADD . /build

# Kick off the actual build (removes /build when finished)
RUN ./build/build.sh

# Syncthing's ports
EXPOSE 8080 22000 21025/udp

# The config directory and the data directory are volumes.
VOLUME ["/home/syncthing/.config/syncthing", "/home/syncthing/repos"]

# Run syncthing
CMD ["/usr/local/bin/init"]
