FROM andrewd/busybox-nix

# Add the build script
ADD ./build.sh /build.sh

# When this is used as a base image, we load and run the provided closure.
ONBUILD ADD ./system.closure /system.closure
ONBUILD RUN /build.sh
