#!/bin/bash

VERSION=7.2.0

CUSTOM_PREFIX=/opt/gcc-$VERSION/

MACHINE=`uname -m`
CUSTOM_LIB="$CUSTOM_PREFIX/lib"

if [ $MACHINE == "x86_64" ]
then
    CUSTOM_LIB="$CUSTOM_PREFIX/lib64"
fi

export PATH=/opt/gcc-$VERSION/bin:$PATH
export LD_LIBRARY_PATH=$CUSTOM_LIB:$LD_LIBRARY_PATH

echo "Custom paths added"
env | grep PATH

echo "Adding custom enviroment variables to force the gcc $VERSION when using make"
echo "Using these LIBs $CUSTOM_LIB"


CUSTOM_GCC=$CUSTOM_PREFIX/bin/$MACHINE-linux-gnu
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
export LDFLAGS="-static-libstdc++ -static-libgcc"


export THREADS=`grep -c ^processor /proc/cpuinfo`

echo Threads detected: $THREADS and stored into \$THREADS variable
echo To take full advantage use: make -j \$THREADS 

bash


#   GNU nano 2.2.4                                                                File: /home/vagrant/cppcheck-1.81/build.sh                                                                                                                                      

# #!/bin/bash

# VERSION=7.2.0
# CROSS_COMPILE=/usr/bin/i586-mingw32msvc

# export CXX=${CROSS_COMPILE}-g++
# export CC=${CROSS_COMPILE}-gcc
# export AS=${CROSS_COMPILE}-as
# export AR=${CROSS_COMPILE}-ar
# export NM=${CROSS_COMPILE}-nm
# export LD=${CROSS_COMPILE}-ld
# export OBJDUMP=${CROSS_COMPILE}-objdump
# export OBJCOPY=${CROSS_COMPILE}-objcopy
# export RANLIB=${CROSS_COMPILE}-ranlib
# export STRIP=${CROSS_COMPILE}-strip

# export PATH="/usr/i586-mingw32msvc/bin:$PATH"

# #export LDFLAGS="-static"

# make clean
# make -j14
# echo "checking build"
# ldd cppcheck

# #bash


