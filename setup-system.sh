#!/bin/bash

set -e
set -u

cd `dirname "$0"`

# sytem update
sudo apt-get update
sudo apt-get dist-upgrade -y

# install etckeeper
sudo apt-get install -y etckeeper bzr

# install language support
check-language-support | xargs sudo apt-get install -y

# install other packages
grep -v ^# ./packages.list | xargs sudo apt-get install -y

# prevent google repository from being added
sudo touch /etc/default/google-talkplugin

# /tmp as tmpfs
if ! grep -qw /tmp /etc/fstab; then
    echo 'tmpfs /tmp tmpfs rw,nosuid,nodev 0 0' | sudo tee -a /etc/fstab
fi

# format swap as a workaround for LP: #1320702
sudo mkswap /dev/mapper/ubuntu--vg-swap_1

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

# change cryptsetup passphrase to stronger one
echo 'cryptsetup passphrase for /dev/sda3'
echo '1. old passphrase'
echo '2. new one'
sudo cryptsetup luksChangeKey /dev/sda3
