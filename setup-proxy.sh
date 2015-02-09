#!/bin/bash

set -e
set -u

## prepare userdata
USERDATA=`mktemp`
SSH_KEY=`cat ~/.ssh/id_rsa.pub`
sed -e "s|{{SSH_KEY}}|$SSH_KEY|" ./cloud-config_squid-deb-proxy.yaml > "$USERDATA"

## create
if ! (sudo lxc-ls --running | grep -q -w squid-deb-proxy); then
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
