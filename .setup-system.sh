#!/bin/bash

set -e
set -u

# install etckeeper
sudo apt-get update
sudo apt-get install -y etckeeper

# install language support
check-language-support | xargs sudo apt-get install -y

# install other packages
grep -v ^# ~/.packages | xargs sudo apt-get install -y

# /tmp as tmpfs
echo 'tmpfs /tmp tmpfs rw,nosuid,nodev 0 0' | sudo tee -a /etc/fstab

# set swappiness
echo 'vm.swappiness = 20' | sudo tee /etc/sysctl.d/99-local.conf

# setup apt-listchanges
cat << EOF | sudo debconf-set-selections
apt-listchanges apt-listchanges/which select both
apt-listchanges apt-listchanges/frontend select pager
apt-listchanges apt-listchanges/email-address string
apt-listchanges apt-listchanges/save-seen boolean true
apt-listchanges apt-listchanges/confirm boolean true
EOF

sudo dpkg-reconfigure -fnoninteractive apt-listchanges
