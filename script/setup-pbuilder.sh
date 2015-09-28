#!/bin/bash

set -e
set -u

# update apt-file database on host
apt-file update

# create pbuilder tarball
for type in devel stable lts; do
    pbuilder-dist `ubuntu-distro-info --$type` create
done
