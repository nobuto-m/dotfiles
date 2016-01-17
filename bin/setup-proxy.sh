#!/bin/bash

set -e
set -u

## prepare userdata
USERDATA=$(mktemp)
trap 'rm -f $USERDATA' 0 INT QUIT ABRT PIPE TERM
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
sed -e "s|{{ ssh_key }}|$SSH_KEY|" template/cloud-config_squid-deb-proxy.yaml > "$USERDATA"

## create
if ! (sudo lxc-ls --running | grep -q -w squid-deb-proxy); then
    sudo lxc-create -n squid-deb-proxy -t ubuntu-cloud -- \
        --release trusty --userdata "$USERDATA"

    cat <<EOF | sudo tee -a /var/lib/lxc/squid-deb-proxy/config
lxc.start.auto = 1
EOF
fi

## launch
sudo lxc-autostart
