dotfiles
========

for setting up my laptop

## BIOS/UEFI setup

An example with ThinkPad.

* Restart
  - Load Factory Defaults - Yes
* Config
  - Keyboard/Mouse
    - F1-F12 as Primary Function - On
  - Display
    - UMA Frame buffer Size - 4G
* Security
  - Secure Boot
    - Allow Microsoft 3rd Party UEFI CA - On

## Install Ubuntu Desktop

1. get [the latest LTS image](https://www.ubuntu.com/download/desktop)
   or [the latest daily-live image](http://cdimage.ubuntu.com/daily-live/current/)

1. create a USB startup disk
   ([Ubuntu](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu),
   [Windows](https://ubuntu.com/tutorials/create-a-usb-stick-on-windows),
   [macOS](https://ubuntu.com/tutorials/create-a-usb-stick-on-macos))

   or

   ```bash
   sudo dd \
       if=/PATH/TO/*-desktop-amd64.iso \
       of=/dev/disk/by-id/usb-PATH-TO-USB-DRIVE-0\:0 \
       bs=4M oflag=direct,sync status=progress
   ```

1. boot up with the USB stick

1. install Ubuntu Desktop with the options below
   * Extended selection (not to remove LibreOffice, Remmina, Shotwell, Simple Scan, etc.)
   * Advanced features
     - Use LVM and encryption (dm-crypt with LUKS)

1. reboot


## Use this repository

1. Tweak keybind for terminal operations per your prefrence first. For example:

   ```bash
   gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
   ```

1. Optional steps
   - replace the default mirror URL with a preferred one in
     ```bash
     sudo editor /etc/apt/sources.list.d/ubuntu.sources
     ```
   - enroll a fingerprint, e.g.
     ```bash
     fprintd-enroll -f right-thumb
     ```
   - and update pam configuration for fingerprints with
     ```bash
     sudo pam-auth-update --enable fprintd
     ```

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
* Add another key to LUKS with
  ```bash
  sudo cryptsetup luksAddKey /dev/nvme0n1p3
  ```
* check firmware updates with
  ```bash
  fwupdmgr refresh; fwupdmgr get-updates
  ```
* select color profile from gnome-control-center
* Firefox
  - login to Firefox Sync
  - pin tabs in Firefox including e-mails, calendar, messengers, task-management,
    and docs
  - enable notifications from specific tabs
* setup an OTP device
* override NetworkManager configuration
  - Tethering AP
    ```bash
    nmcli device wifi connect '<SSID>' password '<password>'
    ```
  - Shared connection to other computers
    ```bash
    nmcli connection add type ethernet con-name Wired  # make sure the default wired connection exists
    nmcli connection add type ethernet con-name Shared autoconnect no ipv4.method shared ipv6.method disabled
    ```
* disable Dropbox LAN sync by
  ```bash
  dropbox lansync n
  ```
* git
  - set git `user.name` and `user.email` with
    ```bash
    git config --global user.name '<NAME>'
    git config --global user.email '<EMAIL>'
    ```
  - create `~/.gitconfig_corporate` with `[user] email = '<EMAIL>'` and include it from `~/.gitconfig` by:
    ```bash
    git config --global includeIf.'gitdir:~/src/work/'.path ~/.gitconfig_corporate
    git config --global includeIf.'gitdir:~/src/corporate_private/'.path ~/.gitconfig_corporate
    git config --global includeIf.'gitdir:~/src/openstack/'.path ~/.gitconfig_corporate
    ```
  - set launchpad username with
    ```bash
    git config --global gitubuntu.lpuser '<USER>'
    ```
  - set gerrit username with
    ```bash
    git config --global --add gitreview.username '<USER>'
    ```
* add `export DEBEMAIL='<EMAIL>'` into `~/.bashrc`
* configure Chromium with:
  - set `https://meet.google.com/` as a start-up page
  - set `Show home bottun` to true and set `https://meet.google.com/`
  - `Use Google Translate` - off
* install tailscale and activate it with
  ```bash
  sudo tailscale up --shields-up --accept-routes
  ```
* Restore those files manually if necessary:
  - ~/.config/hub
  - ~/.local/share/juju/credentials.yaml
* install [unite-shell](https://github.com/hardpixel/unite-shell) extension by hand
  ```bash
  rsync --dry-run -av --delete ~/src/misc/unite-shell/unite@hardpixel.eu/ ~/.local/share/gnome-shell/extensions/unite@hardpixel.eu/
  ```
* install [Greasemonkey / Tampermonkey scripts](https://github.com/nobuto-m/greasemonkey-scripts)

### Firefox add-ons

* https://addons.mozilla.org/firefox/addon/yaru-hybrid-unofficial/
* https://addons.mozilla.org/firefox/addon/tampermonkey/
* https://addons.mozilla.org/firefox/addon/mousedictionary/
  - Manage Extension Shortcuts
    + "Activate the extension": `Alt+Z`
* https://addons.mozilla.org/firefox/addon/most-recent-tab/
  - Manage Extension Shortcuts
    + "Main: Jump to the previously viewed tab, the most recent tab": `Alt+0`
* https://addons.mozilla.org/firefox/addon/tab-session-manager/
  - "Save the session regularly": `false`
* https://addons.mozilla.org/firefox/addon/ublock-origin/
  - userSettings
    + contextMenuEnabled: `false` (Uncheck "Make use of context menu where appropriate")
  - hostnameSwitchesString
    + no-cosmetic-filtering: `* true` (Check "Disable cosmetic filtering")
  - with the following [filters](https://adguard.com/kb/general/ad-filtering/adguard-filters/#adguard-filters):
    + `adguard-widgets` ("AdGuard – Widgets" under "AdGuard - Annoyances") to suppress live support chats
    + `adguard-cookies`, `ublock-cookies-adguard` ("AdGuard/uBO – Cookie Notices") to suppress cookie notices
    + `JPN-1` ("jp: AdGuard Japanese")
  - userFilters
    + `@@||googletagmanager.com^$script` not to break or slow down page loadings
  - Trusted sites
    ```
    chrome-extension-scheme
    moz-extension-scheme
    amazon.co.jp
    google.com
    youtube.com
    ```
* https://addons.mozilla.org/firefox/addon/url2clipboard/


#### Disabled

* https://addons.mozilla.org/firefox/addon/multi-account-containers/
* https://addons.mozilla.org/firefox/addon/markdown-here/
* https://addons.mozilla.org/firefox/addon/text-fragment/
* https://addons.mozilla.org/firefox/addon/user-agent-switcher-revived/
* https://addons.mozilla.org/firefox/addon/wappalyzer/
