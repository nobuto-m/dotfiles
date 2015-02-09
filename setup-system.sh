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
## LP: #1409555
sudo sed -i -e 's/^deb.*extras\.ubuntu\.com.*/# \0/' /etc/apt/sources.list
sudo apt-get update
sudo apt-get install eatmydata
sudo eatmydata apt-get dist-upgrade -y

# install etckeeper
sudo eatmydata apt-get install -y etckeeper bzr

# install other packages
grep -v ^# ./packages.list | xargs sudo eatmydata apt-get install -y

# install language support
check-language-support | xargs sudo eatmydata apt-get install -y

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

# setup MTA
echo 'Please input your mail address for MTA:'
read -r mta_address
echo 'Please input your mail password for MTA:'
read -rs mta_password

sudo -E sed -i \
    -e "s/^\(root=\).*/\1$mta_address/" \
    -e 's/^\(mailhub=\).*/\1smtp.gmail.com:587/' \
    -e '/^UseSTARTTLS=/d' \
    -e '/^AuthUser=/d' \
    -e '/^AuthPass=/d' \
    /etc/ssmtp/ssmtp.conf
cat << EOF | sudo tee -a /etc/ssmtp/ssmtp.conf
UseSTARTTLS=Yes
AuthUser=$mta_address
AuthPass=$mta_password
EOF

# create squid-deb-proxy lxc instance
## prepare lxc-net
sudo sed -i \
    -e 's|\(LXC_ADDR=\).*|\1"10.0.7.1"|' \
    -e 's|\(LXC_NETWORK=\).*|\1"10.0.7.0/24"|' \
    -e 's|\(LXC_DHCP_RANGE=\).*|\1"10.0.7.50,10.0.7.254"|' \
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
