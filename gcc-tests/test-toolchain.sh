#!/bin/bash

VERSION=7.2.0

if [ $# -eq 1 ]
then
    VERSION=$1
fi

echo "********** TESTING TOOLCHAIN VERSION $VERSION *******"


export PATH=/opt/gcc-$VERSION/bin:$PATH
export LD_LIBRARY_PATH=/opt/gcc-$VERSION/lib64:$LD_LIBRARY_PATH

rm test_lambda 2> /dev/null
rm test_assert 2> /dev/null
rm test_concurrent_do 2> /dev/null

echo "----------- TEST LAMBDA ----------"
g++-$VERSION -Wall -pedantic test_lambda.cpp -o test_lambda
ldd test_lambda
./test_lambda

echo "----------- TEST FORTRAN CONCURENT ----------"
gfortran-$VERSION test_concurrent_do.f90 -o test_concurrent_do
ldd test_concurrent_do
./test_concurrent_do

echo "----------- TEST STATIC ASSERT ----------"
echo "On gcc 7.1 (and probablty 7.2 too) has only experimental of C++17, so it will not compile"
echo "---------------------"
g++-$VERSION -std=c++1z -Wall -pedantic test_assert.cpp -o test_assert
ldd test_assert
./test_assert

