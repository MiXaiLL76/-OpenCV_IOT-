SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_VERSION 1)

SET(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc)
SET(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)
SET(CMAKE_SYSROOT /home/stepanoff/raspberry/rootfs_pi_ubuntu)

SET(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_CXX_FLAGS "-std=c++2a")

SET(CMAKE_EXE_LINKER_FLAGS "-Wl,-rpath,/usr/lib/aarch64-linux-gnu -Wl,-rpath,/usr/local/lib -Wl,-rpath,/lib/aarch64-linux-gnu -L /usr/lib/aarch64-linux-gnu -L /lib/aarch64-linux-gnu -L /usr/local/lib")


include_directories(
	${CMAKE_SYSROOT}/usr/include
	${CMAKE_SYSROOT}/usr/local/include
	${CMAKE_SYSROOT}/usr/include/aarch64-linux-gnu/
	${CMAKE_SYSROOT}/usr/lib/gcc/aarch64-linux-gnu/8/include
	${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/glib-2.0/include/
)

set(dlib_needed_libraries ${dlib_needed_libraries} ${CMAKE_EXE_LINKER_FLAGS} )

set(ENV{PKG_CONFIG_DIR} "/usr/lib/aarch64-linux-gnu/pkgconfig/")
set(ENV{PKG_CONFIG_SYSROOT_DIR} ${CMAKE_SYSROOT})
