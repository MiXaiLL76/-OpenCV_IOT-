#!/bin/bash

su="sudo"
apt_tool="${su} apt"

indexOf(){
# indexOf "asdsad" "a"
  echo "$1" "$2" | awk '{print index($1,$2)}' 
}

dpkg_test(){
  find_str="no packages found"
  line=`dpkg -l $1 | grep $1`

  if [ "$(echo ${line} | awk '{print length}')" == '0' ]; then
      ${apt_tool} update
      ${apt_tool} install $1 -y
  fi
}

### Обновление пакетов, нужных для установки
dpkg_test debconf
dpkg_test debhelper
dpkg_test lintian
dpkg_test bc
dpkg_test fakeroot

new_fakeroot="fakeroot-tcp"
${su} update-alternatives --set fakeroot /usr/bin/${new_fakeroot}
### Для сборки пакета

# Название пакета
pack_name="opencv"
arch="armhf"

# Тут можно почитать о такого рода сборке
info="Build with [https://habr.com/ru/post/78094]"
date_now=$(date +%Y.%m.%d)
date_all=$(date +%'a, %d %b %Y %H:%M:%S %z')

# полный путь до скрипта
ABSOLUTE_FILENAME=`readlink -e "$0"`
# каталог в котором лежит скрипт
DIRECTORY=`dirname "${ABSOLUTE_FILENAME}"`
# Текущая директория
pwd_root=$(pwd)

# Обновление версии пакета
version=$(gcc ${DIRECTORY}/get_ver_cv.c -I ${pwd_root} && ./a.out && rm a.out)

# Директория с файлами для сборки пакета
root="${HOME}/${pack_name}_deb"

# Удаление предыдущей сборки
${su} rm -rf ${root}

# Создание папок
mkdir -p ${root}
mkdir -p ${root}/DEBIAN

make install PREFIX=${root}/usr/local

mkdir -p ${root}/usr/lib/python3/dist-packages
ln -s ${root}/usr/local/lib/python3.7/dist-packages/cv2 ${root}/usr/lib/python3/dist-packages/cv2

cp ${root}/usr/local/lib/python3.7/dist-packages/cv2/python-3.7/cv2.cpython-*-gnu.so ${root}/usr/local/lib/python3.7/dist-packages/cv2/python-3.7/cv2.so





mkdir -p ${root}/usr/lib/arm-linux-gnueabihf/pkgconfig

{
  echo "libdir = ${root}/usr/local/lib"
  echo "includedir = ${root}/usr/local/include/opencv4"
  echo ""
  echo "Name: OpenCV"
  echo "Description: OpenCV (Open Source Computer Vision Library) is an open source computer vision and machine learning software library."
  echo "Version: ${version}"
  echo "Libs: -L${libdir} -lopencv_calib3d -lopencv_core -lopencv_dnn -lopencv_features2d -lopencv_flann -lopencv_gapi -lopencv_highgui -lopencv_imgcodecs -lopencv_imgproc -lopencv_ml -lopencv_objdetect -lopencv_photo -lopencv_stitching -lopencv_videoio -lopencv_video"
  echo "Cflags: -I${includedir}"
} > ${root}/usr/lib/arm-linux-gnueabihf/pkgconfig/opencv.pc

sizebyte=$(du ${root} -c -b | grep total | awk '{print $1}')
let "sizekb = sizebyte / 1024"
let "sizekb = sizekb + (sizekb / 100) * 20";

# Сборка контрольных файлов
{
  echo "Package: ${pack_name}"
  echo "Version: ${version}.dev"
  echo "Maintainer: MiXaiLL76 <mike.milos@yandex.ru>"
  echo "Architecture: ${arch}"
  echo "Section: misc"
  echo "Description: OpenCV builded for RPI3b+"
  echo "Installed-Size: ${sizekb}"
  echo "Priority: optional"
  echo "Origin: MiXaiLL76 brain"
} > ${root}/DEBIAN/control

{
  echo "Создатель пакета MiXaiLL76, т.е. я."
  echo "Телефон: +79201393940"
  echo "Почта: mike.milos@yandex.ru"
} > ${root}/DEBIAN/copyright

{
  echo "${pack_name} (${version}.dev) stable; urgency=medium"
  echo ""
  echo "* Testing."
  echo ""
  echo "-- MiXaiLL76 <mike.milos@yandex.ru> ${date_all}"
} > ${root}/DEBIAN/changelog


# Раздаём папкам правильные права
chmod 775 -R ${root}

# Собираем пакет
${new_fakeroot} dpkg-deb --build ${root}
# Копируем пакет обратно в текущую директорию
mv ${root}.deb  ${DIRECTORY}/${pack_name}_${arch}_${version}.dev.deb

# Вывод информации
echo ""
echo ""
echo ${info}
echo ""
echo "This root is: ${pwd_root}"
echo "Created package is: ${DIRECTORY}/${pack_name}_${arch}_${version}.dev.deb"

${su} rm -rf ${root}