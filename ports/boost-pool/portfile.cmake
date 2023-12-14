# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/pool
    REF boost-${VERSION}
    SHA512 2bb41cba37b9e9f4546ad5337f90a252629135ee6ca824f338d0bb2aa8a2572650096dcc9ce2601a30d2b4d8b1379916b82319602fbad51506368c3c8662f3e9
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
