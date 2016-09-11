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

1. Shrink / to 120G

    ```bash
    $ sudo lvresize /dev/ubuntu-vg/root -L 120G --resizefs
```

1. reboot


## Use this repository

1. install git and ansible first

    ```bash
$ sudo apt update && sudo apt install git ansible
```

1. clone the repo

    ```bash
$ git clone https://github.com/nobuto-m/dotfiles.git
```

1. execute

    ```bash
$ cd dotfiles/
$ make setup
```

1. download backup

   Login to the backup server from console with password, then copy temporary ssh public key.

    ```bash
$ make restore
```

1. full setup

    ```bash
$ make full-setup
```

## Manual setup

### Firefox add-ons

* https://addons.mozilla.org/firefox/addon/password-hasher/
* https://addons.mozilla.org/firefox/addon/searchwp/
* https://addons.mozilla.org/firefox/addon/searchbox-sync/
* https://addons.mozilla.org/firefox/addon/markdown-here/
* https://addons.mozilla.org/firefox/addon/gnotifier/
* https://addons.mozilla.org/firefox/addon/greasemonkey/
* https://github.com/mooz/keysnail/wiki/keysnail-japanese

### remaining manual steps

* login to Firefox Sync
* pin tabs of e-mails, calendar, task-management, time-tracking and grammar-checker
* enable Desktop Notifications in Firefox for Gmail
* install [greasemonkey scripts](https://github.com/nobuto-m/greasemonkey-scripts)
* select color profile from gnome-control-center
* import VPN config into network-manager
* adjust microphone volume
