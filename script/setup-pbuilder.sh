#!/bin/bash

set -e
set -u

# update apt-file database on host
apt-file update

# create pbuilder tarball
for type in devel stable lts; do
    ubuntu-distro-info --$type
done | sort -u | xargs -L1 -I{} pbuilder-dist {} create

rm -f ~/pbuilder/aptcache/ubuntu/*.deb
