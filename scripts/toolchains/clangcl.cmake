if(NOT _VCPKG_CLANGCL_TOOLCHAIN)
set(_VCPKG_CLANGCL_TOOLCHAIN 1)

find_program(CMAKE_C_COMPILER "clang-cl.exe" REQUIRED)
find_program(CMAKE_CXX_COMPILER "clang-cl.exe" REQUIRED) 

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(_vcpkg_clangcl_arch "-m32")
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(_vcpkg_clangcl_arch "-m64")
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    set(_vcpkg_clangcl_arch "--target=arm-pc-windows-msvc")
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(_vcpkg_clangcl_arch "--target=arm64-pc-windows-msvc")
endif()

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES ${_vcpkg_clangcl_arch})

set(VCPKG_MSVC_ENABLE_MP OFF)

get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )
if(NOT _CMAKE_IN_TRY_COMPILE)

    string(APPEND VCPKG_C_FLAGS " ${_vcpkg_clangcl_arch}")
    string(APPEND VCPKG_CXX_FLAGS " ${_vcpkg_clangcl_arch}")

endif()

if(DEFINED XBOX_CONSOLE_TARGET)
    include("${CMAKE_CURRENT_LIST_DIR}/xbox.cmake")
else()
    include("${CMAKE_CURRENT_LIST_DIR}/windows.cmake")
endif()

endif()
