INCLUDE (CMakeForceCompiler)
SET (CMAKE_SYSTEM_NAME Linux)     # this one is important
SET (CMAKE_SYSTEM_VERSION 1)      # this one not so much
SET( CMAKE_VERBOSE_MAKEFILE on )
# Set up some paths for the build
SET(TOOLCHAIN_DIR "/home/fanxiang/qualcomm/azure-iot-sdk/OpenWrt-Toolchain-ar71xx-for-mips_34kc-gcc-4.8-linaro_uClibc-0.9.33.2/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2")
SET (CMAKE_SYSROOT ${TOOLCHAIN_DIR})
SET(CMAKE_INCLUDE_PATH ${TOOLCHAIN_DIR}/usr/include)
LIST(APPEND CMAKE_INCLUDE_PATH ${TOOLCHAIN_DIR}/include)
SET (CMAKE_LIBRARY_PATH ${TOOLCHAIN_DIR}/usr/lib)
LIST(APPEND CMAKE_LIBRARY_PATH ${TOOLCHAIN_DIR}/lib)

SET (Boost_INCLUDE_DIR "/home/fanxiang/qualcomm/azure-iot-sdk/boost_1_64_0/boostmlinux-1-64-0/include")
SET (Boost_LIBRARY_DIR_RELEASE "/home/fanxiang/qualcomm/azure-iot-sdk/boost_1_64_0/boostmlinux-1-64-0/lib")

# Set up the compilers and the flags
SET (CMAKE_C_COMPILER ${TOOLCHAIN_DIR}/bin/mips-openwrt-linux-gcc)
SET (CMAKE_CXX_COMPILER ${TOOLCHAIN_DIR}/bin/mips-openwrt-linux-g++)

SET(CMAKE_CXX_FLAGS "-g -O0 -Wall -fprofile-arcs -ftest-coverage ${CMAKE_CXX_FLAGS} ")
SET(CMAKE_C_FLAGS "-g -O0 -Wall -W -fprofile-arcs -ftest-coverage ${CMAKE_C_FLAGS}")


# This is the file system root of the target
SET (CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_DIR})

# Search for programs in the build host directories
SET (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# For libraries and headers in the target directories
SET (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)

SET (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
