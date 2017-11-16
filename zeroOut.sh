#!/bin/bash

# Run this before packing the vagrant image, helps with fragmentation

# remove downloaded packages
sudo apt-get clean

sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
