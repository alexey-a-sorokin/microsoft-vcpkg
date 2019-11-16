# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/core
    REF boost-1.71.0
    SHA512 ebb4f3aaca25804452dd9fb5b47ec089193eef8ce902629f71513bf85a1c9d9ec4bc829a3aa53a6ccb3310a18469b06fd1ed01905851da28fd52040195ede7f4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
