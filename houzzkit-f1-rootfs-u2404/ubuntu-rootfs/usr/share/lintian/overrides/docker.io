# This script is not used nor installed by the package
docker.io: script-without-interpreter [config]

# config script would duplicate the debconf prompt during installation and
# upgrade. For more info, read the comment in the postinst script.
docker.io: no-debconf-config

# This is fine for a Go binary
docker.io: statically-linked-binary [usr/bin/docker-init]
