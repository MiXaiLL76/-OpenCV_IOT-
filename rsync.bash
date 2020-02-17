#!/bin/bash

piIp=${1}

tc_dir=${HOME}/raspberry/rootfs_pi

function sync {
fullpathname=${tc_dir}${1}
fullpathname="${fullpathname%/*}"

mkdir -p -m 755 ${fullpathname}
rsync -rlvc \
--progress \
--info=progress2 \
--delete-after \
--safe-links  \
pi@${piIp}:${1} ${fullpathname}
}

include=(\
/opt/vc/lib \
/opt/vc/include \
/usr/lib/arm-linux-gnueabihf \
/usr/include \
/usr/local/include \
/usr/local/lib \
/usr/local/lib/pkgconfig \
/usr/share/pkgconfig \
/lib/arm-linux-gnueabihf \
/usr/lib/python3 \
)

for dir in ${include[@]}
do
sync ${dir}
done

cp ${tc_dir}/usr/lib/arm-linux-gnueabihf/libm.a ${tc_dir}/usr/lib/libm.a
ln -s ${HOME}/raspberry/rootfs_pi/usr/include/arm-linux-gnueabihf ${HOME}/raspberry/rootfs_pi/usr/include/x86_64-linux-gnu 
