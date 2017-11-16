#!/bin/bash

VERSION=7.2.0

CUSTOM_PREFIX=/opt/gcc-$VERSION/

BIT=`uname -m`
CUSTOM_LIB="$CUSTOM_PREFIX/lib"

if [ $BIT == "x86_64" ]
then
    CUSTOM_LIB="$CUSTOM_PREFIX/lib64"
fi

export PATH=/opt/gcc-$VERSION/bin:$PATH
export LD_LIBRARY_PATH=$CUSTOM_LIB:$LD_LIBRARY_PATH

echo "Custom paths added"
env | grep PATH

echo "Adding custom enviroment variables to force the gcc $VERSION when using make"


CUSTOM_GCC=$CUSTOM_PREFIX/bin/i686-linux-gnu
export CXX=${CUSTOM_GCC}-g++-$VERSION
export CC=${CUSTOM_GCC}-gcc-$VERSION
export AS=${CUSTOM_GCC}-as-$VERSION
export AR=${CUSTOM_GCC}-ar-$VERSION
export NM=${CUSTOM_GCC}-nm-$VERSION
export LD=${CUSTOM_GCC}-ld-$VERSION
export OBJDUMP=${CUSTOM_GCC}-objdump-$VERSION
export OBJCOPY=${CUSTOM_GCC}-objcopy-$VERSION
export RANLIB=${CUSTOM_GCC}-ranlib-$VERSION
export STRIP=${CUSTOM_GCC}-strip-$VERSION


#export LDFLAGS="-static -L $CUSTOM_LIB"

export THREADS=`grep -c ^processor /proc/cpuinfo`

echo Threads detected: $THREADS and stored into \$THREADS variable
echo To take full advantage use: make -j \$THREADS 

bash