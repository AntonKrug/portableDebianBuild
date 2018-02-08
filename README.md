# Introduction

These scripts will create a **vagrant friendly** virtualbox machine focused on building **portable binaries**. Where the project can be build statically while linky the libc dynamicaly to avoid problems. Because the Debian 6 has **libc 2.11** which is fairly old it should run on many other distributions without any issue. Because the bundled gcc in jessie is 4.4.5 it might miss many required features. And could cause many projects to fail while building. This repository contains scripts to build and test a custom **gcc 7.2.0** build which will remedy this constrain.

Below there are instuction how to build, but if you want to just use it, here are the finished and published vagrant images:

[Vagrant Images](https://app.vagrantup.com/antonkrug)

# Preparation of the distribution

Download the archive of the official DVD ISO installers of Debian 6 jessie:

[jessie 32bit ISO](https://cdimage.debian.org/cdimage/archive/6.0.10/i386/iso-dvd/)

[jessie 64bit ISO](https://cdimage.debian.org/cdimage/archive/6.0.10/amd64/iso-dvd/)

## VirtualBox Settings compatible with vagrant
Create machine with few GB of ram and few cores (later it can be increased). The idea is making the first image less resource demanding and generic, and after publishing the image then increasing to the full extend. The inner script do detect  how many threads are allocated to the VM and they do increase the build speeds. If the user is not interested in the vagrant publishing, then the large VM can be generated right now.
* Enable I/O APIC - for to support multicore systems
* Disable audio
* Disable USB - not needed with vagrant (but might be needed for the GUI mouse to be usable)
* Disable floppy drive
* For HDD storage use **VMDK** format around 60GB of size. It's not needed, but it's hard to resize the partition so it's good to have it ready for any future projects users will build with this.
* For networking use NAT, but in advanced add **portforwaring** (Name:SSH hostPort:2222 guestPort:22)

## Install base debian
When installing the distribution use the default settings except few cases:
* Root password:**vagrant**
* user name:**vagrant**
* user password:**vagrant**
* Install the standard base system + SSH server as shown in the in image below:
![screenshot of the package selection](/images/softwareSelection.png)

## First stage of preparation

After the distribution is installed fetch the first stage script and run it:

```bash
wget --no-check-certificate \
https://raw.githubusercontent.com/AntonKrug/portableDebianBuild/master/prepareDistribution.sh

chmod a+x prepareDistribution.sh
./prepareDistribution.sh
```

It will ask for root password which should be **vagrant** and install decent amount of packages. And then reboot the machine, if everything goes well you should boot into KDM. With user vagrant and password vagrant you should log into a desktop enviroment (you could enable automatic login if you wish)

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
        * Advanced
            * Session Manager
                * Start with an empty sessions
            * Service manager
                * Disable services:
                    * PowerDevil
                    * Update notifier
                    * Nepomuk
            * Power Managment
                * Do not lock screen on resume
                * Do not let power devil manage powersaving
    * Konsole -> Settings -> Edit current profile -> Appearance -> Disable font smoothing

# VirtualBox Guest Additions

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

## Using the Guest Additions

* Devices -> Shared Clipboard -> Bidirectional
* Devices -> Shared Folders (if you desire so)

# Building gcc

```bash
cd ~/portableDebianBuild
./gcc-download-build-install.sh
```

# Publishing Vagrant image

Follow these instructions:

[Building vagrant box from start](https://www.engineyard.com/blog/building-a-vagrant-box-from-start-to-finish)

The instructions should be followed only from the "Package the box" section and below.

# Usage 

The gcc 7.2 is in the /opt/gcc-7.2.0, to use it run the prepareEnviroment.sh which will put it into the path and then it does create enviroment variables pointing to the custom toolchain for these:

CXX, CC, AS, AR, NM, LD, OBJDUMP, OBJCOPY, RANLIB, STRIP

Use the updateScripts.sh from time to time to make sure the scripts are up-to-date

# Use cases

## uWebSockets

Building more portable version of the 32 bit uWebSockets library:

```bash
vagrant init antonkrug/debian6-32-portable-build --box-version 1.0.0
vagrant up
vagrant ssh

sudo apt-get install zlib1g-dev

export PATH=/opt/gcc-7.2.0/bin/:$PATH
export LD_LIBRARY_PATH=/opt/gcc-7.2.0/lib:$LD_LIBRARY_PATH
export CXX=gcc-7.2.0

wget https://www.openssl.org/source/openssl-1.1.0g.tar.gz
tar xvf openssl-1.1.0g.tar.gz 
cd openssl-1.1.0g
./config
make -j32  #or whatever cores you have
sudo make install

git clone https://github.com/uNetworking/uWebSockets.git
cd uWebSockets
make
cp libuWS.so /vagrant/   # will share the result to the host
```
