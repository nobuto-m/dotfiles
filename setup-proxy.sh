#!/bin/bash

set -e
set -u

cd `dirname "$0"`

## prepare userdata
USERDATA=`mktemp`
SSH_KEY=`cat ~/.ssh/id_rsa.pub`
sed -e "s|{{SSH_KEY}}|$SSH_KEY|" ./cloud-config_squid-deb-proxy.yaml > "$USERDATA"

## create
if ! (sudo lxc-ls --running | grep -q -w squid-deb-proxy); then
    sudo lxc-create -n squid-deb-proxy -t ubuntu-cloud -- \
        --release trusty --userdata "$USERDATA"

    ## set static IP address and autostart
    cat <<EOF | sudo tee /var/lib/lxc/squid-deb-proxy/rootfs/etc/network/interfaces.d/eth0.cfg
# The primary network interface
auto eth0
iface eth0 inet static
    address 10.0.7.2
    netmask 255.255.255.0
    gateway 10.0.7.1
    dns-nameservers 10.0.7.1
EOF
    cat <<EOF | sudo tee -a /var/lib/lxc/squid-deb-proxy/config
lxc.start.auto = 1
EOF
fi

## launch
sudo lxc-autostart
