dotfiles
========

for setting up my laptop

## Install Ubuntu Desktop

1. get [the latest LTS image](https://www.ubuntu.com/download/desktop) or [the latest daily-live image](http://cdimage.ubuntu.com/daily-live/current/)

1. create a USB startup disk ([Ubuntu](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-ubuntu), [Windows](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-windows), [macOS](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-macos))

1. boot up with the USB stick

1. install Ubuntu Desktop with the options below (NOTE: installer may crash due to [LP: #1751252](https://launchpad.net/bugs/1751252). In that case, apply [the workaround](https://wiki.ubuntu.com/BionicBeaver/ReleaseNotes#line-403))
   * Encrypt the new Ubuntu installation for security (dm-crypt with LUKS)

1. Shrink / to 120G

    ```bash
    $ sudo lvresize /dev/ubuntu-vg/root -L 120G --resizefs -v
    ```

1. reboot


## Use this repository

1. install git and ansible first

    ```bash
    $ sudo apt update && sudo apt install git make ansible
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

   Login to the backup server from console with password, then copy temporary ssh public key. Once SSH connection is confirmed, execute duplicity.

    ```bash
    $ make restore
    ```

1. full setup

    ```bash
    $ make full-setup
    ```

## Manual setup

### Firefox add-ons

* https://addons.mozilla.org/firefox/addon/markdown-here/
* https://addons.mozilla.org/firefox/addon/greasemonkey/

### remaining manual steps

* login to Firefox Sync
* pin tabs of e-mails, calendar, task-management, time-tracking, grammar-checker and messengers
* install [greasemonkey scripts](https://github.com/nobuto-m/greasemonkey-scripts)
* select color profile from gnome-control-center
* disable Dropbox LAN sync by `dropbox lansync n`
* adjust VPN routes in network-manager
