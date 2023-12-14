# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/mpl
    REF boost-${VERSION}
    SHA512 ca688f951443adbf1816d3b942b9f0e0fe0de973af62298e1923bb5cd0f90effe60895ceba82ccf94a8ce15a8b494bd4c4a233853e8e3cca9b441c728da78d32
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
