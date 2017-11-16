# Introduction

These scripts will create a **vagrant friendly** virtualbox machine focused on building **portable binaries**. Where the project can be build statically while linky the libc dynamicaly to avoid problems. Because the Debian 6 has **libc 2.11** which is fairly old it should run on many other distributions without any issue. Because the bundled gcc in jessie is 4.4.5 it might miss many required features. And could cause many projects to fail while building. This repository contains scripts to build and test a custom **gcc 7.2.0** build which will remedy this constrain.

Below there are instuction how to build, but if you want to just use it, here are the finished and published vagrant images:

[Vagrant Images](https://app.vagrantup.com/antonkrug)

# Preparation of the distribution

Download the archive of the official DVD ISO installers of Debian 6 jessie:

[jessie 32bit ISO](https://cdimage.debian.org/cdimage/archive/6.0.10/i386/iso-dvd/)

[jessie 64bit ISO](https://cdimage.debian.org/cdimage/archive/6.0.10/amd64/iso-dvd/)

## VirtualBox Settings compatible with vagrant
Create machine with few GB of ram and few cores (later it can be increased).
* Enable I/O APIC
* Disable audio
* Disable USB
* Disable floppy drive
* For HDD storage use **VMDK** format around 60GB of size
* For networking use NAT, but in advanced add **portforwaring** (Name:SSH hostPort:2222 guestPort:22)

## Install base debian
When installing the distribution use the default settings except few cases:
* Root password:vagrant
* user name:vagrant
* user password:vagrant
* Install the standard base system + SSH server as shown in the in image below:
![screenshot of the package selection](/images/softwareSelection.png)

## First stage of preparation

After the distribution is installed fetch the first stage script and run it:

```bash
wget --no-check-certificate \ https://raw.githubusercontent.com/AntonKrug/portableDebianBuild/master/prepareDistribution.sh

chmod a+x prepareDistribution.sh
./prepareDistribution.sh
```

It will ask for root password which should be vagrant and install decent amount of packages. And then reboot the machine, if everything goes well you should boot into KDM. With vagrant/vagrant you should log into a desktop enviroment

# Configuring KDE
Just removing unecesarry things so it will not take as much resources:

* Taskbar icons / systray:
    * Quit the KMix
    * KOrganizer Reminder Daemon
        * uncheck Enable reminders
        * uncheck Start daemon on statup
        * Quit
    * Remove Device notifier
    * Configure Search indexer
        * Disable the nepomuk service
    * Or just remove whole system tray

* KMenu / Start :
    * System Settings
        * Appearence
            * Style
                * Workspace -> Air for netbooks
                * Fine Tuning -> Low display resolution and low CPU
            * Fonts -> Use anti-aliasing = Disabled
        * Advanced -> Session Manager
            * Start with an empty sessions
        * Advanced -> Service manager
            * Disable services:
                * PowerDevil
                * Update notifier
                * Nepomuk
    * Konsole -> Settings -> Edit current profile -> Appearance -> Disable font smoothing

# Compiling VirtualBox Guest Additions

In the VirtualBox click Devices -> Inser Guest Additions CD image...

```bash
sudo mount -r /dev/cdrom /media/cdrom

# confirm if will warn about existing additions
/media/cdrom/autorun.sh 

# fix known issue with a display adapter
sudo strip -R .note.ABI-tag /usr/lib/libGL.so.1
sudo ldconfig

#adding file permissions for the shared folders
sudo usermod -aG vboxsf vagrant

sudo reboot
```


# Building gcc

```bash
git clone https://github.com/AntonKrug/portableDebianBuild
cd portableDebianBuild
./gcc-download-build-install
```