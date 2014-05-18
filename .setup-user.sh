#!/bin/bash

set -e
set -u

# set DEBEMAIL and DEBFULLNAME in ~/.bashrc
setup-packaging-environment

# get user's full name and e-mail address
FULLNAME=`getent passwd "$USER" | cut -d: -f5 | cut -d, -f1`
echo 'Your e-mail address:'
read -sr EMAIL

# set id for bzr command
bzr whoami "$FULLNAME <$EMAIL>"

# set login name for launchpad.net
bzr lp-login nobuto

# git config
git config --global user.name "$FULLNAME"
git config --global user.email "$EMAIL"
git config --global color.ui true

# create C locale XDG user dirs
echo ~/{Desktop,Downloads,Templates,Public,Documents,Documents/Music,Documents/Pictures,Documents/Videos} | xargs mkdir

# remove ja locale XDG user dirs and examples.desktop
rmdir ~/{デスクトップ,ダウンロード,テンプレート,公開,ドキュメント,ミュージック,ピクチャ,ビデオ}
rm examples.desktop

# import dconf settings
dconf load / < ~/.config/dconf/dump.txt

# clear /var/crash, sometimes ibus-daemon crashes during `dconf load`
rm -f /var/crash/*.crash

# create ICC profile
# after this step, .icc needs to be chosen manually in gnome-control-center
cd-create-profile --output ~/.local/share/icc/Gamma6200K.icc \
    ~/.local/share/icc/Gamma6200K.xml

# propose reboot
gnome-session-quit --reboot
