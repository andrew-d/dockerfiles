#!/bin/sh

set -e
set -x

# Set up nix environment
source /root/.nix-profile/etc/profile.d/nix.sh

# Import the given closure
nix-store --import < /system.closure

# Clean up after ourselves
rm /system.closure
rm /build.sh
