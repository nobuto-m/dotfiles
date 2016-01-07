#!/bin/bash

set -e
set -u

sudo mkdir -p /etc/default/grub.d/
cat <<"EOF" | sudo tee /etc/default/grub.d/touchpad.cfg
# workaround for LP: #1500504
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT i8042.nomux"
EOF
sudo update-grub
