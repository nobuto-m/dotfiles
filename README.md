dotfiles
========

for setting up my laptop

## BIOS setup

An example with ThinkPad.

* Restart
  - OS Opmimized Defaults - Enabled
  - Load Setup Defaults - Yes
* Config
  - Keyboard/Mouse
    - Fn and Ctrl Key swap - Enabled
    - F1-F12 as Primary Function - Enabled
  - Display
    - Total Graphics Memory - 512MB

## Install Ubuntu Desktop

1. get [the latest LTS image](https://www.ubuntu.com/download/desktop)
   or [the latest daily-live image](http://cdimage.ubuntu.com/daily-live/current/)

1. create a USB startup disk
   ([Ubuntu](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-ubuntu),
   [Windows](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-windows),
   [macOS](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-macos))

1. boot up with the USB stick

1. install Ubuntu Desktop with the options below
   * Encrypt the new Ubuntu installation for security (dm-crypt with LUKS)

1. Shrink / to 120G manually before reboot

    ```bash
    $ sudo lvresize /dev/vgubuntu/root -L 120G --resizefs -v
    ```
    NOTE: older Ubuntu may have "ubuntu-vg" as the VG name instead

1. reboot


## Use this repository

1. Tweak keybind for terminal operations per your prefrence first. For example:

   ```bash
   $ gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
   ```

1. install git, make and ansible

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

1. reboot

1. download backup

   Login to the backup server from console with password, then copy
   temporary ssh public key. Once SSH connection is confirmed, execute
   duplicity.

    ```bash
    $ make restore
    ```

1. full setup

    ```bash
    $ make full-setup
    ```

## Manual setup

### Remaining manual steps

* check firmware updates - `fwupdmgr refresh && fwupdmgr get-updates`
* login to Firefox Sync
* pin tabs in Firefox including e-mails, calendar, task-management,
  time-tracking, grammar-checker and messengers
* enable notifications from specific tabs
* setup an OTP device
* install [greasemonkey scripts](https://github.com/nobuto-m/greasemonkey-scripts)
* select color profile from gnome-control-center
* disable Dropbox LAN sync by `dropbox lansync n`
* set git `user.name` and `user.name` with `git config --global`
* create `~/.gitconfig_COMPANY` with `[user] email = EMAIL` and include it from `~/.gitconfig` by:
  - `git config --global includeIf.'gitdir:~/src/openstack/'.path ~/.gitconfig_COMPANY`
  - `git config --global includeIf.'gitdir:~/src/COMPANY/'.path ~/.gitconfig_COMPANY`
* set gerrit username with `git config --global --add gitreview.username "USER"`
* configure Chromium with:
  - set `https://meet.google.com/` as a start-up page
  - `Offer to translate pages that aren't in a language you read` - off

### Firefox add-ons

* https://addons.mozilla.org/firefox/addon/multi-account-containers/
* https://addons.mozilla.org/firefox/addon/ff-tab-suspender/
* https://addons.mozilla.org/firefox/addon/markdown-here/
* https://addons.mozilla.org/firefox/addon/greasemonkey/
* https://addons.mozilla.org/firefox/addon/mousedictionary/
