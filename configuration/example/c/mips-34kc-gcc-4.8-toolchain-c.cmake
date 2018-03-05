INCLUDE(CMakeForceCompiler)

SET(CMAKE_SYSTEM_NAME Linux)     # this one is important
SET(CMAKE_SYSTEM_VERSION 1)      # this one not so much
SET( CMAKE_VERBOSE_MAKEFILE on )
# This is the file system root of the target
SET(TOOLCHAIN_DIR "/home/fanxiang/qualcomm/azure-iot-sdk/OpenWrt-Toolchain-ar71xx-for-mips_34kc-gcc-4.8-linaro_uClibc-0.9.33.2/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2")
SET(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_DIR})
SET(CMAKE_SYSROOT ${TOOLCHAIN_DIR})
SET(CMAKE_LIBRARY_PATH ${TOOLCHAIN_DIR}/usr/lib)
LIST(APPEND CMAKE_LIBRARY_PATH ${TOOLCHAIN_DIR}/lib)

SET(CMAKE_INCLUDE_PATH ${TOOLCHAIN_DIR}/usr/include)
LIST(APPEND CMAKE_INCLUDE_PATH ${TOOLCHAIN_DIR}/include)

SET(CMAKE_C_COMPILER ${TOOLCHAIN_DIR}/bin/mips-openwrt-linux-gcc)
SET(CMAKE_CXX_COMPILER ${TOOLCHAIN_DIR}/bin/mips-openwrt-linux-g++)

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
