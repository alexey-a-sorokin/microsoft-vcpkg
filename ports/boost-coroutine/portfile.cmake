# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/coroutine
    REF boost-${VERSION}
    SHA512 39c5ce76aa2270959b61816e31b3ad0c2d900443655cf6ce1b59a59fcdb7100570da92d8400d357c98d13f4eb98c464f7af021988bfd65d8997e6c7b957a910f
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
