dotfiles
========

for setting up my laptop

## BIOS/UEFI setup

An example with ThinkPad.

* Restart
  - OS Opmimized Defaults - On
  - Load Setup Defaults - Yes
* Config
  - Keyboard/Mouse
    - Fn and Ctrl Key swap - On
    - F1-F12 as Primary Function - On
* Security
  - Secure Boot
    - Allow Microsoft 3rd Party UEFI CA - On

## Install Ubuntu Desktop

1. get [the latest LTS image](https://www.ubuntu.com/download/desktop)
   or [the latest daily-live image](http://cdimage.ubuntu.com/daily-live/current/)

1. create a USB startup disk
   ([Ubuntu](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-ubuntu),
   [Windows](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-windows),
   [macOS](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-macos))

   or

   ```bash
   sudo dd \
       if=/PATH/TO/*-desktop-amd64.iso \
       of=/dev/disk/by-id/usb-PATH-TO-USB-DRIVE-0\:0 \
       bs=4M oflag=direct,sync status=progress
   ```

1. boot up with the USB stick

1. install Ubuntu Desktop with the options below
   * Full installation (not to remove LibreOffice, Remmina, Shotwell, Simple Scan, etc.)
   * Advanced features
     - Use LVM with the new Ubuntu installation
     - Encrypt the new Ubuntu installation for security (dm-crypt with LUKS)

1. reboot


## Use this repository

1. Tweak keybind for terminal operations per your prefrence first. For example:

   ```bash
   gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
   ```

1. choose a mirror server(optional) and enroll fingerprints(optional)
   - replace the default mirror URL in `/etc/apt/sources.list`
   - enroll fingerprints and update pam configuration with `sudo pam-auth-update --enable fprintd`

1. install git, make and ansible

    ```bash
    sudo apt update && sudo apt install git make ansible
    ```

1. clone the repo

    ```bash
    git clone https://github.com/nobuto-m/dotfiles.git
    ```

1. execute

    ```bash
    cd dotfiles/
    make setup
    ```

1. reboot

1. download backup

   Login to the backup server from console with password, then copy
   temporary ssh public key. Once SSH connection is confirmed, execute
   duplicity.

    ```bash
    make restore
    ```

1. full setup

    ```bash
    make full-setup
    ```

## Manual setup

### Remaining manual steps

* login with X session
* Add another key to LUKS with `sudo cryptsetup luksAddKey /dev/nvme0n1p3`
* check firmware updates - `fwupdmgr refresh; fwupdmgr get-updates`
* select color profile from gnome-control-center
* Firefox
  - login to Firefox Sync
  - pin tabs in Firefox including e-mails, calendar, messengers, task-management,
    and docs
  - enable notifications from specific tabs
* setup an OTP device
* override NetworkManager configuration
  - Tethering AP
    - `nmcli device wifi connect "<SSID>" password "<password>"`
  - Shared to other computers
    - `nmcli connection add type ethernet con-name Wired` (default)
    - `nmcli connection add type ethernet con-name Shared autoconnect no ipv4.method shared ipv6.method disabled`
* disable Dropbox LAN sync by `dropbox lansync n`
* git
  - set git `user.name` and `user.email` with `git config --global`
  - create `~/.gitconfig_corporate` with `[user] email = EMAIL` and include it from `~/.gitconfig` by:
    - `git config --global includeIf.'gitdir:~/src/work/'.path ~/.gitconfig_corporate`
    - `git config --global includeIf.'gitdir:~/src/corporate_private/'.path ~/.gitconfig_corporate`
    - `git config --global includeIf.'gitdir:~/src/openstack/'.path ~/.gitconfig_corporate`
  - set launchpad username with `git config --global gitubuntu.lpuser "USER"`
  - set gerrit username with `git config --global --add gitreview.username "USER"`
* add `export DEBEMAIL=` into `~/.bashrc`
* configure Chromium with:
  - set `https://meet.google.com/` as a start-up page
  - set `Show home bottun` to true and set `https://meet.google.com/`
  - `Use Google Translate` - off
* install tailscale and activate it with `sudo tailscale up --shields-up --accept-routes`
* Restore those files manually if necessary:
  - ~/.config/hub
  - ~/.local/share/juju/credentials.yaml
* install [unite-shell](https://github.com/hardpixel/unite-shell) extension by hand
* install a patched wpasupplicant by hand for the time being
  - https://bugs.launchpad.net/ubuntu/+source/wpa/+bug/1987252
* install [greasemonkey scripts](https://github.com/nobuto-m/greasemonkey-scripts)

### Firefox add-ons

* https://addons.mozilla.org/firefox/addon/yaru-hybrid-unofficial/
* https://addons.mozilla.org/firefox/addon/tampermonkey/
* https://addons.mozilla.org/firefox/addon/mousedictionary/
* https://addons.mozilla.org/firefox/addon/most-recent-tab/
* https://addons.mozilla.org/firefox/addon/tab-session-manager/

#### Disabled

* https://addons.mozilla.org/firefox/addon/wappalyzer/
* https://addons.mozilla.org/firefox/addon/multi-account-containers/
* https://addons.mozilla.org/firefox/addon/markdown-here/
* https://addons.mozilla.org/firefox/addon/user-agent-switcher-revived/
