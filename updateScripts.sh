#!/bin/sh

cd ~/portableDebianBuild

#force git pull overide files
git fetch --all
git reset --hard origin/master

chmod a+x *.sh
