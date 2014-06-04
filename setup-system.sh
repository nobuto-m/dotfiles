#!/bin/bash

set -e
set -u

cd `dirname "$0"`

# change cryptsetup passphrase to stronger one
echo 'cryptsetup passphrase for /dev/sda3'
echo '1. old passphrase'
echo '2. new one'
sudo cryptsetup luksChangeKey /dev/sda3

# sytem update
sudo apt-get update
sudo apt-get dist-upgrade -y

# install etckeeper
sudo apt-get install -y etckeeper bzr

# install other packages
grep -v ^# ./packages.list | xargs sudo apt-get install -y

# install language support
check-language-support | xargs sudo apt-get install -y

# prevent google repository from being added
sudo touch /etc/default/google-talkplugin

# /tmp as tmpfs
if ! grep -qw /tmp /etc/fstab; then
    echo 'tmpfs /tmp tmpfs rw,nosuid,nodev 0 0' | sudo tee -a /etc/fstab
fi

# format swap as a workaround for LP: #1320702
sudo swapoff -a
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

# change IP address range of virbr0
sudo virsh net-destroy default
sudo sed -i -e 's/192\.168\.122\./192.168.123./g' /etc/libvirt/qemu/networks/default.xml
sudo restart libvirt-bin
sudo virsh net-start default

# create squid-deb-proxy lxc instance
## prepare lxc-net
sudo sed -i \
    -e 's|\(LXC_ADDR=\).*|\1"10.0.7.1"|' \
    -e 's|\(LXC_NETWORK=\).*|\1"10.0.7.0/24"|' \
    -e 's|\(LXC_DHCP_RANGE=\).*|\1"10.0.7.2,10.0.7.254"|' \
    /etc/default/lxc-net
sudo restart lxc-net

## prepare ssh key
[ -e ~/.ssh/id_rsa.pub ] || ssh-keygen -N '' -f ~/.ssh/id_rsa

## prepare userdata
USERDATA=`mktemp`
SSH_KEY=`cat ~/.ssh/id_rsa.pub`
sed -e "s|{{SSH_KEY}}|$SSH_KEY|" ./cloud-config_squid-deb-proxy.yaml > "$USERDATA"

if ! (sudo lxc-ls --running | grep -q -w squid-deb-proxy); then
    ## create
    sudo lxc-create -n squid-deb-proxy -t ubuntu-cloud -- \
        --release trusty --userdata "$USERDATA"

    ## set static IP address and autostart
    cat <<EOF | sudo tee -a /var/lib/lxc/squid-deb-proxy/config

lxc.network.ipv4 = 10.0.7.2/24
lxc.network.ipv4.gateway = 10.0.7.1
lxc.start.auto = 1
EOF
fi

## launch
sudo lxc-autostart

echo 'Done!'
