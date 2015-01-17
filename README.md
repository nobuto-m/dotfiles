dotfiles
========

for setting up my laptop

## Install Ubuntu Desktop

1. get [the latest daily-live image](http://cdimage.ubuntu.com/daily-live/current/)

1. create a USB startup disk ([Ubuntu](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-ubuntu), [Windows](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-windows))

1. copy SHA256SUM and SHA256SUM.gpg into the USB stick to verify signature later 

1. boot up with the USB stick

1. install Ubuntu Desktop with the options below
   * Encrypt the new Ubuntu installation for security (dm-crypt with LUKS)
   * Encrypt my home folder (eCryptfs)

1. reboot


## Use this repository

1. install git first

    ```bash
$ sudo apt-get update && sudo apt-get install git
```

1. clone the repo

    ```bash
$ git clone https://github.com/nobuto-m/dotfiles.git
```

1. execute

    ```bash
$ dotfiles/setup-system.sh
$ dotfiles/setup-user.sh
$ dotfiles/setup-pbuilder.sh
```

## Manual setup

### copy files from deja-dup backup

* `~/.vpn/`
* `~/.ssh/config`
* `~/.ssh/id_rsa*`
* `~/.gnupg/pubring.gpg`
* `~/.gnupg/secring.gpg`
* `~/.gnupg/trustdb.gpg`
* `~/.local/share/keyrings/login.keyring`
* `~/.purple/accounts.xml`
* `~/.purple/blist.xml`

### Firefox add-ons

* https://addons.mozilla.org/firefox/addon/password-hasher/
* https://addons.mozilla.org/firefox/addon/click-to-play-per-element/
* https://addons.mozilla.org/firefox/addon/searchwp/
* https://addons.mozilla.org/firefox/addon/searchbox-sync/
* https://addons.mozilla.org/firefox/addon/eijiro-on-the-web/
* https://addons.mozilla.org/firefox/addon/markdown-here/
* https://addons.mozilla.org/firefox/addon/gnotifier/
* https://addons.mozilla.org/firefox/addon/greasemonkey/
* https://github.com/mooz/keysnail/wiki/keysnail-japanese

### Thunderbird add-ons

* https://addons.mozilla.org/thunderbird/addon/confirm-address-5582/

### remaining manual steps

* install third party packages listed in `packages-thirdparty.txt`
* create VPN config in network-manager
* select color profile from gnome-control-center
* set background trancparency of gnome-terminal
* enable markerline and joinpart plugin in Pidgin
* forcibly enable gtkspell for Pidgin in ja_JP locale
  - `ln -s en_US.aff /usr/share/hunspell/ja_JP.aff`
  - `ln -s en_US.dic /usr/share/hunspell/ja_JP.dic`
