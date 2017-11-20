#!/bin/bash

#set the strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

su root -c 'echo "deb http://archive.debian.org/debian squeeze main non-free contrib" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install sudo && \
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant && \
    chmod 0440 /etc/sudoers.d/vagrant && \
    /etc/init.d/sudo restart'

sudo apt-get -y install make mc dkms aptitude build-essential cmake htop git curl
sudo apt-get -y install libtool pkg-config automake autoconf texlive bison flex doxygen chrpath nsis dos2unix mingw-w64
sudo apt-get -y install autotools-dev libglib2.0-dev libx11-dev libxext-dev libudev-dev libconfuse-dev libboost-all-dev 

#optional desktop enviroment
sudo apt-get -y install kde-full 

#if gnome was not selected probably not needed, but just to be sure
sudo apt-get -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-utils 

echo "Adding vagrant key"
mkdir -p /home/vagrant/.ssh
chown -R vagrant /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys

echo "AuthorizedKeysFile %h/.ssh/authorized_keys" | sudo tee -a /etc/apt/sources.list
sudo /etc/init.d/ssh restart


cd ~
git clone https://github.com/AntonKrug/portableDebianBuild
cd portableDebianBuild
chmod a+x *.sh


#clean downloaded packages
sudo apt-get clean

echo "Everything done, press enter to reboot"
read line

sudo reboot