# UBUNTU 19.10, RaspberryPi 3b+, ARMv8

## Скомпилированную библиотеку, готовую к установке можно скачать в **[релизах](https://github.com/MiXaiLL76/OpenCV-IOT/releases)**

## Установка необходимых библиотек

```
sudo apt install -y build-essential autoconf automake cmake unzip pkg-config gcc-aarch64-linux-gnu g++-aarch64-linux-gnu gfortran-aarch64-linux-gnu libgfortran5-arm64-cross gcc rsync
```

```
ubuntu@ubuntu:~$ sudo apt install -y rsync libavcodec-dev libavcodec-dev libavresample-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev gfortran cmake git pkg-config wget libpython3-dev libgtk-3-dev libcanberra-gtk3-dev libdc1394-22-dev libgphoto2-dev ffmpeg libfontconfig1-dev libcairo2-dev libgdk-pixbuf2.0-dev libpango1.0-dev libgtkglext1-dev
```

Нужно создать Toolchain из библиотек файловой системы raspberrypi. Для этого я сделал скрипт **rsync.bash**

Устанавливаем ```deviceIP="192.168.1.5"``` и запускаем его ```rsync.bash ${deviceIP}```

У нас на нашем компьютере создается папка с библиотеками **/raspberry/rootfs_pi_ubuntu** в домашней дириктории. Синхронизация дело не быстрое, нужно подождать какое то время.

Так же, я уже создал файл **toolchain_rpi.cmake**, который необходим для компиляции библиотеки на нашем компьютере

```
deviceIP="192.168.1.5"
bash rsync.bash ${deviceIP}
```


## Компиляция и настройка

Я подготовил специальный скрипт который устанавливает последний билд [opencv](https://github.com/opencv/opencv)
Но перед этим я настоятельно **РЕКОМЕНДУЮ** установить мои библиотеки которые я специально скомпилировал для rpi.
Советую обе библиотеки ставить с правами супер пользователя. 

- [OpenBLAS](https://github.com/MiXaiLL76/OpenBLAS-IOT)
- [NumPY](https://github.com/MiXaiLL76/Numpy-OpenBLAS-IOT)

```
bash build.bash
```

Почему то стандартная компиляция не поддерживает тестовый код **LAPACK**, поэтому я сделал заглушку (мы то знаем что [openblas](https://github.com/MiXaiLL76/OpenBLAS_IOT) имеет lapack)

## Сборка пакета OpenCV

Для сборки подготовлен специальный скрипт **deb.bash**. Он соберет все исходные коды и применит дополнительные переносы библиотек.

```
bash deb.bash
```

## Перенос пакета

```
scp opencv_arm64*.deb ubuntu@${deviceIP}:~
```

## Тестирование

```
ubuntu@ubuntu:~$ python3
Python 3.7.5 (default, Nov 20 2019, 09:21:52)
[GCC 9.2.1 20191008] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import cv2
>>> cv2.__version__
'4.3.0-pre'
```

## Синтетический тест

> ARM64

```
ubuntu@ubuntu:~$ DISPLAY=:50 python3 video_test.py

FPS min: 0
FPS max: 30
FPS mean: 16.148011782032402
```

> ARMHF

```
pi@raspberrypi:~/test-video $ python video_test.py 

FPS min: 0
FPS max: 21
FPS mean: 10.857142857142858

```
### ПРИБАВКА ПО СКОРОСТИ РАБОТЫ У МЕНЯ СОСТАВИЛА 60% ОТНОСИТЕЛЬНО ARMHF DEBIAN 10

## Полезная информация, за которую очень благодарен авторам.
[Кросс-компиляция OpenCV 4 для Raspberry Pi](https://solarianprogrammer.com/2018/12/18/cross-compile-opencv-raspberry-pi-raspbian/)

[Установка GUI на Raspbian Lite](https://www.raspberrypi.org/forums/viewtopic.php?t=133691)

[Автозапуск приложений](https://www.raspberrypi.org/forums/viewtopic.php?t=132637)

[OpenCV](https://github.com/opencv/opencv)

[OpenBLAS](https://github.com/xianyi/OpenBLAS)

[ali_m](https://stackoverflow.com/users/1461210/ali-m) & [Compiling numpy with OpenBLAS](https://stackoverflow.com/questions/11443302/compiling-numpy-with-openblas-integration/14391693#14391693)