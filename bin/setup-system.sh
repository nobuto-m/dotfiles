#!/bin/bash

set -e
set -u

# enable -proposed
cat > /etc/apt/sources.list.d/proposed.list <<EOF
deb http://jp.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-proposed main restricted universe multiverse
deb-src http://jp.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-proposed main restricted universe multiverse
EOF

cat > /etc/apt/preferences.d/proposed <<EOF
Package: *
Pin: release a=*-proposed
Pin-Priority: 400
EOF

# add PPA
apt-add-repository -y ppa:juju/stable
apt-add-repository -y ppa:juju/devel
apt-add-repository -y ppa:indicator-presentation/ppa

# sytem update
apt update
apt install -y eatmydata
eatmydata apt upgrade -y

apt_install() {
    env DEBIAN_FRONTEND=noninteractive eatmydata apt install -y -- "$@"
}

# install etckeeper
apt_install etckeeper

# install other packages
# shellcheck disable=SC2046
apt_install $(grep -v ^# ./packages.list)

# install language support
# shellcheck disable=SC2046
apt_install $(check-language-support)
sed -i -e 's/[a-zA-Z_]\+.UTF-8/en_US.UTF-8/' /etc/default/locale

# /tmp as tmpfs
cp /usr/share/systemd/tmp.mount /etc/systemd/system/

# switch to swap file
echo 'vm.swappiness = 1' > /etc/sysctl.d/99-local.conf
swapoff -a
sed -i -e 's|^/dev/mapper/cryptswap1 .*|#\0|' /etc/fstab
sed -i -e 's|^cryptswap1 .*|#\0|' /etc/crypttab
cryptsetup close cryptswap1 || true
lvremove -f ubuntu-vg/swap_1 || true

fallocate -l 6G /swapfile
chmod 0600 /swapfile
mkswap /swapfile || true
cat > /etc/systemd/system/swapfile.swap <<EOF
[Unit]
Documentation=man:systemd.swap(5)

[Swap]
What=/swapfile

[Install]
WantedBy=swap.target
EOF
systemctl enable swapfile.swap

# create a partition for lxc/kvm dirs
lvcreate -l 100%FREE -n virt ubuntu-vg || true
if ! lsblk -f /dev/mapper/ubuntu--vg-virt | grep -qw ext4; then
    mkfs.ext4 /dev/mapper/ubuntu--vg-virt || true
fi
if ! grep -qw ubuntu--vg-virt /etc/fstab; then
    echo /dev/mapper/ubuntu--vg-virt /var/lib/lxc ext4 noatime,nobarrier 0 3 >> /etc/fstab
fi

# turn off sound on lightdm
sudo -u lightdm -H dbus-launch dconf write /com/canonical/unity-greeter/play-ready-sound false
# set HiDPI for unity-greeter
sudo -u lightdm -H dbus-launch dconf write /com/canonical/unity-greeter/xft-dpi 128.0

# power management
## enable ALPM
## https://wiki.ubuntu.com/Kernel/PowerManagementALPM
echo SATA_ALPM_ENABLE=true > /etc/pm/config.d/sata_alpm
## kick pm-powersave, LP: #1461386
cat > /etc/udev/rules.d/99-pm-powersave.rules <<EOF
SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="/usr/sbin/pm-powersave true"
SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="/usr/sbin/pm-powersave false"
EOF
## disable pm-powersave on suspend, LP: #1455097
cat <<"EOF" | install /dev/stdin -m 0755 /lib/systemd/system-sleep/00powersave
#!/bin/sh
case $1 in
    pre)    pm-powersave false ;;
    post)   pm-powersave ;;
    *)      exit 1 ;;
esac
exit 0
EOF

# setup apt-listchanges
cat << EOF | debconf-set-selections
apt-listchanges apt-listchanges/which select both
apt-listchanges apt-listchanges/frontend select pager
apt-listchanges apt-listchanges/email-address string
apt-listchanges apt-listchanges/save-seen boolean true
apt-listchanges apt-listchanges/confirm boolean true
EOF

dpkg-reconfigure -fnoninteractive apt-listchanges

# change IP address range of virbr0
virsh net-destroy default || true
sed -i -e 's/192\.168\.122\./192.168.123./g' /etc/libvirt/qemu/networks/default.xml

# openvswitch network in libvirt
ovs-vsctl add-br br-ovs0 || true
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
sed -i \
    -e 's|\(LXC_ADDR=\).*|\1"10.0.7.1"|' \
    -e 's|\(LXC_NETWORK=\).*|\1"10.0.7.0/24"|' \
    -e 's|\(LXC_DHCP_RANGE=\).*|\1"10.0.7.50,10.0.7.254"|' \
    -e 's|#*\(LXC_DHCP_CONFILE=.*\)|\1|' \
    -e 's|#*\(LXC_DOMAIN="lxc"\)|\1|' \
    /etc/default/lxc-net

cat >/etc/lxc/dnsmasq.conf <<EOF
dhcp-host=squid-deb-proxy,10.0.7.2,336h
EOF

# prevent google repository from being added
touch /etc/default/google-talkplugin

# force --unsafe-caching for juju, LP: #1505435
cat <<"EOF" | install -m 755 /dev/stdin /usr/local/bin/uvt-kvm
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
echo 'Ready to reboot? [ENTER]'
head -n1
reboot
