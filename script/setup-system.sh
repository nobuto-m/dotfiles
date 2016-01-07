#!/bin/bash

set -e
set -u

# enable -proposed
cat <<EOF | sudo tee /etc/apt/sources.list.d/proposed.list
deb http://jp.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-proposed main restricted universe multiverse
deb-src http://jp.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-proposed main restricted universe multiverse
EOF

cat <<EOF | sudo tee /etc/apt/preferences.d/proposed
Package: *
Pin: release a=*-proposed
Pin-Priority: 400
EOF

# add PPA
sudo apt-add-repository -y ppa:juju/stable
sudo apt-add-repository -y ppa:indicator-presentation/ppa

# sytem update
sudo apt update
sudo apt install -y eatmydata
sudo eatmydata apt full-upgrade -y
sudo apt-get autoremove --purge -y

apt_install() {
    sudo env DEBIAN_FRONTEND=noninteractive eatmydata apt install -y -- $@
}

# install etckeeper
apt_install etckeeper
if [ ! -e /etc/.etckeeper ]; then
    sudo etckeeper init
    sudo etckeeper commit 'Initial commit'
fi

# install other packages
apt_install $(grep -v ^# ./packages.list)

# install language support
apt_install $(check-language-support)
sudo sed -i -e 's/[a-zA-Z_]\+.UTF-8/en_US.UTF-8/' /etc/default/locale

# /tmp as tmpfs
if ! grep -qw /tmp /etc/fstab; then
    echo 'tmpfs /tmp tmpfs rw,nosuid,nodev 0 0' | sudo tee -a /etc/fstab
fi

# switch to swap file
echo 'vm.swappiness = 10' | sudo tee /etc/sysctl.d/99-local.conf
sudo swapoff -a
sudo sed -i -e 's|^/dev/mapper/cryptswap1 .*|#\0|' /etc/fstab
sudo sed -i -e 's|^cryptswap1 .*|#\0|' /etc/crypttab
sudo cryptsetup close cryptswap1 || true
sudo lvremove -f ubuntu-vg/swap_1 || true

sudo fallocate -l 6G /swapfile
sudo chmod 0600 /swapfile
sudo mkswap /swapfile || true
if ! grep -qw /swapfile /etc/fstab; then
    echo /swapfile swap swap defaults 0 0 | sudo tee -a /etc/fstab
fi

# create btrfs for lxc/kvm dirs
sudo lvcreate -l 100%FREE -n virt ubuntu-vg || true
if ! lsblk -f /dev/mapper/ubuntu--vg-virt | grep -qw ext4; then
    sudo mkfs.ext4 /dev/mapper/ubuntu--vg-virt || true
fi
if ! grep -qw ubuntu--vg-virt /etc/fstab; then
    echo /dev/mapper/ubuntu--vg-virt /var/lib/lxc ext4 noatime,nobarrier 0 3 | sudo tee -a /etc/fstab
fi

## turn off sound on lightdm
sudo -u lightdm -H dbus-launch dconf write /com/canonical/unity-greeter/play-ready-sound false
## set HiDPI for unity-greeter
sudo -u lightdm -H dbus-launch dconf write /com/canonical/unity-greeter/xft-dpi 128.0

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

# openvswitch network in libvirt
sudo ovs-vsctl add-br br-ovs0 || true
cat <<EOF | virsh net-define /dev/stdin || true
<network>
  <name>br-ovs0</name>
  <forward mode='bridge'/>
  <bridge name='br-ovs0'/>
  <virtualport type='openvswitch'/>
</network>
EOF
virsh net-autostart br-ovs0

# change IP address range of lxcbr0
sudo sed -i \
    -e 's|\(LXC_ADDR=\).*|\1"10.0.7.1"|' \
    -e 's|\(LXC_NETWORK=\).*|\1"10.0.7.0/24"|' \
    -e 's|\(LXC_DHCP_RANGE=\).*|\1"10.0.7.50,10.0.7.254"|' \
    -e 's|#*\(LXC_DHCP_CONFILE=.*\)|\1|' \
    -e 's|#*\(LXC_DOMAIN="lxc"\)|\1|' \
    /etc/default/lxc-net

cat << EOF | sudo tee /etc/lxc/dnsmasq.conf
dhcp-host=squid-deb-proxy,10.0.7.2,336h
EOF

# enable all tunables in powertop
cat <<EOF | sudo tee /etc/systemd/system/powertop.service
[Service]
Environment=TERM=linux
ExecStart=/usr/sbin/powertop --quiet --auto-tune

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable powertop

# prevent google repository from being added
sudo touch /etc/default/google-talkplugin

# force --unsafe-caching for juju, LP: #1505435
cat <<"EOF" | sudo install -m 755 /dev/stdin /usr/local/bin/uvt-kvm
#!/bin/sh

set -e
set -u

if [ "$1" = 'create' ]; then
    shift
    # LP: #1505435, LP: #1397201
    /usr/bin/uvt-kvm create "$@" --unsafe-caching --cpu 2 --memory 1536
else
    /usr/bin/uvt-kvm "$@"
fi
EOF

echo 'Done!'

# propose reboot
gnome-session-quit --reboot
