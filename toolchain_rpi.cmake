SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_VERSION 1)

SET(CMAKE_C_COMPILER /usr/bin/arm-linux-gnueabihf-gcc)
SET(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++)
SET(CMAKE_SYSROOT /home/stepanoff/raspberry/rootfs_pi)

SET(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_CXX_FLAGS "-std=c++2a")

SET(CMAKE_EXE_LINKER_FLAGS "-Wl,-rpath,/usr/lib/arm-linux-gnueabihf -Wl,-rpath,/opt/vc/lib  -Wl,-rpath,/usr/local/lib -Wl,-rpath,/lib/arm-linux-gnueabihf -L /usr/lib/arm-linux-gnueabihf -L /lib/arm-linux-gnueabihf -L /opt/vc/lib -L /usr/local/lib")


include_directories(
	${CMAKE_SYSROOT}/usr/include
	${CMAKE_SYSROOT}/usr/local/include
	${CMAKE_SYSROOT}/usr/include/arm-linux-gnueabihf/
	${CMAKE_SYSROOT}/usr/lib/gcc/arm-linux-gnueabihf/8/include
	${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/glib-2.0/include/
)

set(dlib_needed_libraries ${dlib_needed_libraries} ${CMAKE_EXE_LINKER_FLAGS} )

set(ENV{PKG_CONFIG_DIR} "/usr/lib/arm-linux-gnueabihf/pkgconfig/")
set(ENV{PKG_CONFIG_SYSROOT_DIR} ${CMAKE_SYSROOT})
