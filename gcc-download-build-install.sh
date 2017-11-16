#!/bin/bash

#anton krug 15.11.2017
#inspired by https://solarianprogrammer.com/2016/10/07/building-gcc-ubuntu-linux/
 

VERSION=7.2.0
#VERSION=7.1.0
#VERSION="{$VERSION:-7.1.0}"
BUILD_DIR=gcc-$VERSION-build
THREADS=`grep -c ^processor /proc/cpuinfo`
ARCH=`uname -m`

if [ $ARCH == "x86_64" ]
then
 ARCH=x86_64-linux-gnu
else 
 ARCH=i686-linux-gnu
fi

echo GCC $VERSION building for $ARCH

create_opt() {
    sudo chown vagrant:vagrant /opt
    sudo mkdir /opt/redistribute 2> /dev/null
}

clean() {
    echo clean
    cd ~
    rm gcc-$VERSION.tar.xz 2> /dev/null
    rm gcc-$VERSION.tar.gz 2> /dev/null
    rm -rf gcc-$VERSION 2> /dev/null
    rm -rf $BUILD_DIR 2> /dev/null
    rm -rf /opt/gcc-$VERSION 2> /dev/null
    rm -rf /opt/gcc-$VERSION-redistribute.zip 2> /dev/null
}

download() {
    cd ~
    echo download
    wget http://gcc.parentingamerica.com/releases/gcc-$VERSION/gcc-$VERSION.tar.gz
    #tar -xJf gcc-$VERSION.tar.xz 
    tar -xzf gcc-$VERSION.tar.gz
    cd gcc-$VERSION
    ./contrib/download_prerequisites
}

build() {
    echo build
    
    cd ~
    mkdir $BUILD_DIR
    cd $BUILD_DIR

    set -euo pipefail #http://redsymbol.net/articles/unofficial-bash-strict-mode/

    ../gcc-$VERSION/configure --prefix=/opt/gcc-$VERSION -v --build=$ARCH --host=$ARCH --target=$ARCH --enable-checking=release --enable-languages=c,c++,fortran --disable-multilib --program-suffix=-$VERSION
    make -j $THREADS
    set +euo
}

install_all() {
    echo "install"
    cd ~/
    cd $BUILD_DIR
    make install
}

distribute() {
    cd /opt/
    rm -rf /opt/redistribute/gcc 2> /dev/null
    ln -s ../gcc-$VERSION ./redistribute/gcc
    zip -r gcc-$VERSION-redistribute.zip redistribute
}

run_test() {
    set +euo
    export PATH=/opt/gcc-$VERSION/bin:$PATH
    export LD_LIBRARY_PATH=/opt/gcc-$VERSION/lib64:$LD_LIBRARY_PATH
    
    cd ~/portableDebianBuild/gcc-tests
    ./test-toolchain.sh $VERSION
}

create_opt
clean
download
build
install_all
distribute
run_test
