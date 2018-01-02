# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/proto
    REF boost-1.66.0
    SHA512 bf15dc60d07be6e0198c3afd9ca232561e7e919957a0c28b8558bc6bea25e9c3b64af7efa573daeda657e8f6657dc3c11570776261dc29cc4e50356a5b67333a
    HEAD_REF master
)

boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
