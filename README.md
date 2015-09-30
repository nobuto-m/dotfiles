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
$ sudo apt update && sudo apt install git
```

1. clone the repo

    ```bash
$ git clone https://github.com/nobuto-m/dotfiles.git
```

1. execute

    ```bash
$ cd dotfiles/
$ make setup-system
$ make setup-user
$ make setup-pbuilder
```

## Manual setup

### copy files from deja-dup backup

1. login to the backup server from console with password
1. copy ssh public key
1. `lxc-attach -n backup-samba`
1. `passwd backup-samba`
1. `sshuttle -r <backup server> -N`
1. run deja-dup and restore files into `~/backup/`
1. `dotfiles/backup-restore.sh`

### Firefox add-ons

* https://addons.mozilla.org/firefox/addon/password-hasher/
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

* login to Firefox Sync
* enable Desktop Notifications in Firefox for Gmail
* install [greasemonkey scripts](https://github.com/nobuto-m/greasemonkey-scripts)
* install third party packages listed in `packages-thirdparty.txt`
* create VPN config in network-manager
* select color profile from gnome-control-center
