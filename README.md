dot-files
=========

to setup my laptop

## install Ubuntu

1. get the latest daily-live

1. create a USB startup disk

1. copy SHA256SUM and SHA256SUM.gpg into the USB stick to verify signature later 

1. boot up with the USB stick

1. install with those options below
   * enable encrypted LVM (LUKS+dm-crypt)
   * enable encrypted home directory (eCryptfs)

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
