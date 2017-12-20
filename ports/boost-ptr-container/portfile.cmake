# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/ptr_container
    REF boost-1.66.0
    SHA512 4a90951b6467a4bc97ef9426b1a3d29178084c3033664ef1717926592e515d446b4a8f0c42d1bb640d7a82d7219514f5370f16744bbd8bfbc922b2f5b2c85180
    HEAD_REF master
)

boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
