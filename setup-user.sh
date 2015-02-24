#!/bin/bash

set -e
set -u

cd `dirname "$0"`

# copy repository contents
rsync -rv --exclude '/[^.]*' --exclude '/.git/' . ~/

# set DEBEMAIL and DEBFULLNAME in ~/.bashrc
if ! grep -qw DEBEMAIL ~/.bashrc; then
    setup-packaging-environment
fi

# get DEBFULLNAME and DEBEMAIL to setup bzr and git
DEBFULLNAME=`grep -w DEBFULLNAME ~/.bashrc | cut -d'"' -f2`
DEBEMAIL=`grep -w DEBEMAIL ~/.bashrc | cut -d'"' -f2`

# set id for bzr command
bzr whoami "$DEBFULLNAME <$DEBEMAIL>"

# set login name for launchpad.net
bzr lp-login nobuto

# git config
git config --global user.name "$DEBFULLNAME"
git config --global user.email "$DEBEMAIL"
git config --global push.default simple

# create C locale XDG user dirs
echo ~/{Desktop,Downloads,Templates,Public,Documents,Documents/Music,Documents/Pictures,Documents/Videos} | xargs mkdir -p

# remove unneeded XDG user dirs and examples.desktop
rmdir ~/{Music,Pictures,Videos} 2>/dev/null || true
rm -f ~/examples.desktop

# clear gtk bookmarks
rm -f ~/.config/gtk-3.0/bookmarks

# import dconf settings
dconf reset -f /
dconf load / < ~/.config/dconf/dump.txt

# clear /var/crash, sometimes ibus-dconf crashes during `dconf load`
sleep 5
rm -f /var/crash/*.crash || true

# create ICC profile
# after this step, .icc needs to be chosen manually in gnome-control-center
cd-create-profile --output ~/.local/share/icc/Gamma6200K.icc \
    ~/.local/share/icc/Gamma6200K.xml

# caff
caff || true

mta_address=`grep ^AuthUser /etc/ssmtp/ssmtp.conf | cut -d= -f2`
mta_address=`echo $mta_address | cut -d= -f2`

sed -i -e "s/^\(\$CONFIG{'email'} = \).*/\1'$mta_address';/" -e "s/^\(\$CONFIG{'keyid'} = \).*/\1\[ qw{75910B785FAC9400} \];/" ~/.caffrc


echo 'Done!'

# propose reboot
gnome-session-quit --reboot
