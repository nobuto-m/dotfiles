dot-files
=========

for setting up my laptop

## install Ubuntu Desktop

1. get the latest daily-live image

   http://cdimage.ubuntu.com/daily-live/current/

1. create a USB startup disk
   * http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-ubuntu
   * http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-windows

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
$ git clone https://github.com/nobuto-m/dot-files.git
```

1. execute

    ```bash
$ dot-files/setup-system.sh
$ dot-files/setup-user.sh
```

## manual setup

remaining manual steps

* select color profile from gnome-control-center

