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

#optional desktop enviroment
sudo apt-get -y install kde-full 

#if gnome was not selected probably not needed, but just to be sure
sudo apt-get -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-utils 

#clean downloaded packages
sudo apt-get clean
sudo reboot