#!/bin/bash

#anton krug 20.11.2017
#inspired by:
# http://pete.akeo.ie/2010/07/compiling-mingw-w64-with-multilib-on.html
# https://sourceforge.net/p/mingw-w64/mailman/message/35537983/
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
 

VERSION=7.2.0
THREADS=`grep -c ^processor /proc/cpuinfo`
ARCH=`uname -m`

if [ $ARCH == "x86_64" ]
then
 ARCH=x86_64-linux-gnu
else 
 ARCH=i686-linux-gnu
fi

echo GCC $VERSION building for $ARCH

clean_install_dir() {
    rm -rf /usr/local/x86_64-w64-mingw32 2> /dev/null
    sudo mkdir /usr/local/x86_64-w64-mingw32 2> /dev/null
    sudo chown -R vagrant:vagrant /usr/local/x86_64-w64-mingw32 2> /dev/null
}

clean_downloads() {
    echo clean downloads

    rm ~/mingw-build/gcc-$VERSION.tar.gz 2> /dev/null
    rm ~/mingw-build/binutils-2.29.tar.xz 2> /dev/null
    rm ~/mingw-build/mingw-w64-v5.0.3.zip 2> /dev/null
}

clean_extracted() {
    echo clean extracted
    
    rm -rf ~/mingw-build/gcc-$VERSION 2> /dev/null
    rm -rf ~/mingw-build/binutils-2.29 2> /dev/null
    rm -rf ~/mingw-build/mingw-w64-v5.0.3 2> /dev/null
}

clean_build() {
    echo clean extracted
    
    rm -rf ~/mingw-build/gcc-$VERSION/build 2> /dev/null
    rm -rf ~/mingw-build/binutils-2.29/build 2> /dev/null
    rm -rf ~/mingw-build/mingw-w64-v5.0.3/build 2> /dev/null
}

download() {
    echo download

    mkdir ~/mingw-build
    cd ~/mingw-build

    wget -c http://gcc.parentingamerica.com/releases/gcc-$VERSION/gcc-$VERSION.tar.gz -O gcc-$VERSION.tar.gz
    tar -xzf gcc-$VERSION.tar.gz
    cd gcc-$VERSION
    ./contrib/download_prerequisites
    cd ..

    wget -c --no-check-certificate https://ftp.gnu.org/gnu/binutils/binutils-2.29.tar.xz -O binutils-2.29.tar.xz
    tar -xJf binutils-2.29.tar.xz

    wget -c --no-check-certificate https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.3.zip -O mingw-w64-v5.0.3.zip
    unzip mingw-w64-v5.0.3.zip
}

build() {
    echo build
    
    
    #binutils
    mkdir ~/mingw-build/binutils-2.29/build
    cd ~/mingw-build/binutils-2.29/build
    set -euo pipefail 
    #../configure --prefix=/opt/mingw64 --target=x86_64-w64-mingw32 --enable-targets=x86_64-w64-mingw32,i686-w64-mingw32
    #../configure --target=x86_64-w64-mingw32 --enable-targets=x86_64-w64-mingw32,i686-w64-mingw32
    ../configure --prefix=/usr/local/x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --enable-targets=x86_64-w64-mingw32,i686-w64-mingw32 --with-system-zlib
    make -j$THREADS
    make install
    set +euo
    
    #mingw headers
    mkdir ~/mingw-build/mingw-w64-v5.0.3/build
    cd ~/mingw-build/mingw-w64-v5.0.3/build
    set -euo pipefail 
    #../mingw-w64-headers/configure --prefix=/opt/mingw64 --host=x86_64-w64-mingw32
    #../mingw-w64-headers/configure --host=x86_64-w64-mingw32
    ../mingw-w64-headers/configure --prefix=/usr/local/x86_64-w64-mingw32 --host=x86_64-w64-mingw32
    make install
    set +euo

    # symlinks
    mkdir -p /usr/local/x86_64-w64-mingw32/lib32
    ln -s /usr/local/x86_64-w64-mingw32/lib /usr/local/x86_64-w64-mingw32/lib64

    #gcc
    mkdir ~/gcc-$VERSION/build
    cd ~/gcc-$VERSION/build
    ../configure --disable-nls --target=x86_64-w64-mingw32 --enable-languages=c,c++ --with-system-zlib --enable-multilib --enable-version-specific-runtime-libs --enable-shared --enable-fully-dynamic-string
    make all-gcc -j$THREADS
    sudo make install



    #set -euo pipefail
    #../gcc-$VERSION/configure --prefix=/opt/gcc-$VERSION -v --build=$ARCH --host=$ARCH --target=$ARCH --enable-checking=release --enable-languages=c,c++,fortran --disable-multilib --program-suffix=-$VERSION
    #make -j $THREADS
    #set +euo
}

#clean_downloads
#clean_extracted
clean_install_dir
clean_build

download
build
