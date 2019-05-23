# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/crc
    REF boost-1.70.0
    SHA512 7318072d20d80b747991194477d78177345ce67b618d9dd8bbb6a5432673244c04717d5f41f3bf50daf18ff33d612225cd9109578c07019922609a6db4cccb3e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
