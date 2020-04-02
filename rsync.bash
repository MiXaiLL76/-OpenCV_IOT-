#!/bin/bash

piIp=${1}

tc_dir=${HOME}/raspberry/rootfs_pi_ubuntu   

function sync {
fullpathname=${tc_dir}${1}
fullpathname="${fullpathname%/*}"

mkdir -p -m 755 ${fullpathname}
rsync -rlvc \
--progress \
--info=progress2 \
--delete-after \
--safe-links  \
ubuntu@${piIp}:${1} ${fullpathname}
}

include=(\
/usr/lib/aarch64-linux-gnu \
/usr/include \
/usr/local/include \
/usr/local/lib \
/usr/local/lib/pkgconfig \
/usr/share/pkgconfig \
/lib/aarch64-linux-gnu \
/usr/lib/python3 \
)

for dir in ${include[@]}
do
sync ${dir}
done

cp ${tc_dir}/usr/lib/aarch64-linux-gnu/libm.a ${tc_dir}/usr/lib/libm.a
ln -s ${tc_dir}/usr/include/aarch64-linux-gnu ${tc_dir}/usr/include/x86_64-linux-gnu 
