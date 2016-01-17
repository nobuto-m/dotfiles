#!/bin/bash

set -e
set -u

mkdir -p /etc/default/grub.d/

cat > /etc/default/grub.d/touchpad.cfg <<"EOF"
# workaround for LP: #1500504
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT i8042.nomux"
EOF

update-grub
