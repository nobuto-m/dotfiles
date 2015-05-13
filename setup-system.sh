#!/bin/bash

set -e
set -u

cd `dirname "$0"`

sudo true

# change cryptsetup passphrase to stronger one
echo 'cryptsetup passphrase for /dev/sda3'
echo '1. old passphrase'
echo '2. new one'
sudo cryptsetup luksChangeKey /dev/sda3

# sytem update
sudo apt update
sudo apt install -y eatmydata
sudo eatmydata apt full-upgrade -y

# install etckeeper
sudo eatmydata apt install -y etckeeper bzr

# install other packages
grep -v ^# ./packages.list | xargs sudo eatmydata apt install -y

# install language support
check-language-support | xargs sudo eatmydata apt install -y

# prevent google repository from being added
sudo touch /etc/default/google-talkplugin

# /tmp as tmpfs
if ! grep -qw /tmp /etc/fstab; then
    echo 'tmpfs /tmp tmpfs rw,nosuid,nodev 0 0' | sudo tee -a /etc/fstab
fi

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

# change IP address range of virbr0
sudo virsh net-destroy default
sudo sed -i -e 's/192\.168\.122\./192.168.123./g' /etc/libvirt/qemu/networks/default.xml
sudo service libvirt-bin restart

# change IP address range of lxcbr0
sudo sed -i \
    -e 's|\(LXC_ADDR=\).*|\1"10.0.7.1"|' \
    -e 's|\(LXC_NETWORK=\).*|\1"10.0.7.0/24"|' \
    -e 's|\(LXC_DHCP_RANGE=\).*|\1"10.0.7.50,10.0.7.254"|' \
    /etc/default/lxc-net
sudo service lxc-net restart

## lang
sudo sed -i -e 's/[a-zA-Z_]\+.UTF-8/en_US.UTF-8/' /etc/default/locale

## turn off sound on lightdm
sudo -u lightdm -H dbus-launch dconf write /com/canonical/unity-greeter/play-ready-sound false

## add the first user into docker group
sudo adduser $USER docker

echo 'Done!'
