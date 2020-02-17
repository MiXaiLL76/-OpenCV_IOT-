#!/bin/bash

# полный путь до скрипта
ABSOLUTE_FILENAME=`readlink -e "$0"`
# каталог в котором лежит скрипт
DIRECTORY=`dirname "${ABSOLUTE_FILENAME}"`

root="${HOME}/opencv_deb"

replace(){
find=$1
rep=$2
file=$3
sed -i "s@${find}@${rep}@" ${file}
}

cd ${HOME}/raspberry

if ! [ -d ${HOME}/raspberry/opencv ]; then
    git clone https://github.com/opencv/opencv.git
fi

cd ${HOME}/raspberry/opencv

toolchain_sys_root=${HOME}/raspberry/rootfs_pi

replace "try_compile(__VALID_LAPACK" "try_compile(NOT__VALID_LAPACK" cmake/OpenCVFindLAPACK.cmake

if ! [ -d build ]; then
    mkdir -p -m777 build 
fi
cd build

rm -rf *

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=${root}/usr/local/ \
    -D CMAKE_TOOLCHAIN_FILE=${DIRECTORY}/toolchain_rpi.cmake \
    -D CMAKE_SYSTEM_PROCESSOR="ARM" \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_ZLIB=ON \
    -D BUILD_JPEG=ON \
    -D BUILD_TIFF=ON \
    -D BUILD_WEBP=ON \
    include \
    -D PYTHON3_INCLUDE_PATH=${toolchain_sys_root}/usr/include/python3.7m \
    -D PYTHON3_LIBRARIES=${toolchain_sys_root}/usr/lib/arm-linux-gnueabihf/libpython3.7m.so \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=${toolchain_sys_root}/usr/local/lib/python3.7/dist-packages/numpy/core/include \
    -D BUILD_OPENCV_PYTHON3=ON \
    -D BUILD_OPENCV_PYTHON2=OFF \
    -D __VALID_LAPACK=1 \
    -D WITH_FFMPEG=YES \
    -D WITH_CUDA=NO ..


make -j8
