#!/bin/bash

#install debian 6 686/amd64 with only base + ssh (no desktop enviroment)
#run this script with ....

REGULAR_USER=$USER
su root -c 'echo "deb http://archive.debian.org/debian squeeze main non-free contrib" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install sudo && \
    echo "$REGULAR_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant && \
    chmod 0440 /etc/sudoers.d/vagrant && \
    /etc/init.d/sudo restart'

sudo apt-get -y install make mc dkms aptitude build-essential cmake htop git curl
sudo apt-get -y install kde-full #optional
sudo apt-get -y remove virtualbox-ose-guest-x11 virtualbox-ose-guest-utils #if gnome was not selected not needed