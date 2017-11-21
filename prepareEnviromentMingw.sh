#!/bin/bash

VERSION=7.2.0

echo "Adding custom enviroment variables to force the mingw"

PREFIX=x86_64-w64-mingw32
export AR=$PREFIX-ar
export AS=$PREFIX-as
export CC=$PREFIX-gcc
export CXX=$PREFIX-g++
export CPP=$PREFIX-cpp
export LD=$PREFIX-ld
export NM=$PREFIX-nm
export OBJCOPY=$PREFIX-objcopy
export OBJDUMP=$PREFIX-objdump
export RANLIB=$PREFIX-ranlib
export STRIP=$PREFIX-strip

#export LDFLAGS="-static-libstdc++ -static-libgcc"

export THREADS=`grep -c ^processor /proc/cpuinfo`

echo Threads detected: $THREADS and stored into \$THREADS variable
echo To take full advantage use: make -j \$THREADS 


# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the `-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the `PATH' environment variable
#      during execution
#    - add LIBDIR to the `LD_RUN_PATH' environment variable
#      during linking
#    - use the `-LLIBDIR' linker flag
#    - have your system administrator add LIBDIR to `/etc/ld.so.conf'

bash
