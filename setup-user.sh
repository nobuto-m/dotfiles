#!/bin/bash

set -e
set -u

cd `dirname "$0"`

# set DEBEMAIL and DEBFULLNAME in ~/.bashrc
setup-packaging-environment

# get DEBFULLNAME and DEBEMAIL to setup bzr and git
DEBFULLNAME=`grep -w DEBFULLNAME | cut -d'"' -f2`
DEBEMAIL=`grep -w DEBEMAIL | cut -d'"' -f2`

# set id for bzr command
bzr whoami "$DEBFULLNAME <$DEBEMAIL>"

# set login name for launchpad.net
bzr lp-login nobuto

# git config
git config --global user.name "$DEBFULLNAME"
git config --global user.email "$DEBEMAIL"

# create C locale XDG user dirs
echo ~/{Desktop,Downloads,Templates,Public,Documents,Documents/Music,Documents/Pictures,Documents/Videos} | xargs mkdir -p

# remove ja locale XDG user dirs and examples.desktop
rmdir ~/{デスクトップ,ダウンロード,テンプレート,公開,ドキュメント,ミュージック,ピクチャ,ビデオ} 2>/dev/null || true
rm -f examples.desktop

# clear gtk bookmarks
rm -f ~/.config/gtk-3.0/bookmarks

# import dconf settings
dconf load / < ~/.config/dconf/dump.txt

# clear /var/crash, sometimes ibus-daemon crashes during `dconf load`
rm -f /var/crash/*.crash || true

# create ICC profile
# after this step, .icc needs to be chosen manually in gnome-control-center
cd-create-profile --output ~/.local/share/icc/Gamma6200K.icc \
    ~/.local/share/icc/Gamma6200K.xml

# propose reboot
gnome-session-quit --reboot
