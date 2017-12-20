# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/range
    REF boost-1.66.0
    SHA512 98b050cb3e4249c72222d0efac4edbf4cb62ff303dd1634e7e76fea7dff19c62eceb837e8cffbd088fb28b16b98e923f62c7220d5ff424f3c82383a78df97785
    HEAD_REF master
)

boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
