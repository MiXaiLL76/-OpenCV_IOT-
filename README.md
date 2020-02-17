# DEBIAN 10, RaspberryPi 3b+, ARMv7

## Установка необходимых библиотек

```
sudo apt install -y build-essential autoconf \
automake cmake unzip pkg-config gcc-arm-linux-gnueabihf \
g++-arm-linux-gnueabihf gfortran-arm-linux-gnueabihf \
libgfortran3-armhf-cross gcc rsync
```

```
pi@raspberrypi:~ $ sudo apt install -y rsync libavcodec-dev libavcodec-dev libavresample-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev gfortran cmake git pkg-config wget libpython3-dev libgtk-3-dev libcanberra-gtk3-dev libdc1394-22-dev libgphoto2-dev ffmpeg libfontconfig1-dev libcairo2-dev libgdk-pixbuf2.0-dev libpango1.0-dev libgtkglext1-dev
```

Нужно создать Toolchain из библиотек файловой системы raspberrypi. Для этого я сделал скрипт **rsync.bash**

Устанавливаем ```deviceIP="192.168.1.101"``` и запускаем его ```rsync.bash ${deviceIP}```

У нас на нашем компьютере создается папка с библиотеками **/raspberry/rootfs_pi** в домашней дириктории. Синхронизация дело не быстрое, нужно подождать какое то время.

Так же, я уже создал файл **toolchain_rpi.cmake**, который необходим для компиляции библиотеки на нашем компьютере

```
deviceIP="192.168.1.101"
bash rsync.bash ${deviceIP}
```


## Компиляция и настройка

Я подготовил специальный скрипт который устанавливает последний билд [opencv](https://github.com/opencv/opencv)
Но перед этим я настоятельно **РЕКОМЕНДУЮ** установить мои библиотеки которые я специально скомпилировал для rpi.
Советую обе библиотеки ставить с правами супер пользователя. 

- [OpenBLAS](https://github.com/MiXaiLL76/OpenBLAS_IOT)
- [NumPY](https://github.com/MiXaiLL76/numpy_openblas)

```
bash build.bash
```

Почему то стандартная компиляция не поддерживает тестовый код **LAPACK**, поэтому я сделал заглушку (мы то знаем что [openblas](https://github.com/MiXaiLL76/OpenBLAS_IOT) имеет lapack)

## Сборка пакета OpenCV

Для сборки подготовлен специальный скрипт **deb.bash**. Он соберет все исходные коды и применит дополнительные переносы библиотек.

```
bash deb.bash
```


## Полезная информация, за которую очень благодарен авторам.
[Кросс-компиляция OpenCV 4 для Raspberry Pi](https://solarianprogrammer.com/2018/12/18/cross-compile-opencv-raspberry-pi-raspbian/)

[Установка GUI на Raspbian Lite](https://www.raspberrypi.org/forums/viewtopic.php?t=133691)

[Автозапуск приложений](https://www.raspberrypi.org/forums/viewtopic.php?t=132637)

[OpenCV](https://github.com/opencv/opencv)

[OpenBLAS](https://github.com/xianyi/OpenBLAS)

[ali_m](https://stackoverflow.com/users/1461210/ali-m) & [Compiling numpy with OpenBLAS](https://stackoverflow.com/questions/11443302/compiling-numpy-with-openblas-integration/14391693#14391693)