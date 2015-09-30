#!/bin/bash

set -e
set -u

# sytem update
sudo apt update
sudo apt install -y eatmydata
sudo eatmydata apt full-upgrade -y
sudo apt-get autoremove --purge -y

apt_install() {
    sudo env DEBIAN_FRONTEND=noninteractive eatmydata apt install -y -- $@
}

# install etckeeper
apt_install etckeeper bzr

# install other packages
apt_install $(grep -v ^# ./packages.list)

# install language support
apt_install $(check-language-support)
sudo sed -i -e 's/[a-zA-Z_]\+.UTF-8/en_US.UTF-8/' /etc/default/locale

# /tmp as tmpfs
if ! grep -qw /tmp /etc/fstab; then
    echo 'tmpfs /tmp tmpfs rw,nosuid,nodev 0 0' | sudo tee -a /etc/fstab
fi

# disable swap partition
echo 'vm.swappiness = 10' | sudo tee /etc/sysctl.d/99-local.conf
sudo swapoff -a
sudo sed -i -e 's|^/.* swap .*|#\0|' /etc/fstab
sudo sed -i -e 's|^cryptswap1 .*|#\0|' /etc/crypttab
sudo cryptsetup close cryptswap1 || true
sudo lvremove -f ubuntu-vg/swap_1 || true
#sudo lvresize -l +100%FREE ubuntu-vg/root || true
#sudo resize2fs /dev/mapper/ubuntu--vg-root

## turn off sound on lightdm
sudo -u lightdm -H dbus-launch dconf write /com/canonical/unity-greeter/play-ready-sound false
sudo -u lightdm -H dbus-launch dconf write /com/canonical/unity-greeter/xft-dpi 156.0

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
sudo virsh net-destroy default || true
sudo sed -i -e 's/192\.168\.122\./192.168.123./g' /etc/libvirt/qemu/networks/default.xml

# change IP address range of lxcbr0
sudo sed -i \
    -e 's|\(LXC_ADDR=\).*|\1"10.0.7.1"|' \
    -e 's|\(LXC_NETWORK=\).*|\1"10.0.7.0/24"|' \
    -e 's|\(LXC_DHCP_RANGE=\).*|\1"10.0.7.50,10.0.7.254"|' \
    /etc/default/lxc-net

# workaround for LP: #1500504
sudo sed -i -e 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1"quiet splash i8042.nomux"/' /etc/default/grub
sudo update-grub

# prevent google repository from being added
sudo touch /etc/default/google-talkplugin

echo 'Done!'

# propose reboot
gnome-session-quit --reboot
