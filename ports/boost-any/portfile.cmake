# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/any
    REF boost-1.76.0
    SHA512 38f0bf6dddcdf5ce5527d068057de1ce9594605d51dde8f1591decb6423a912be2047fd2ed1b77acf42eb22d5e44a29276db9e9a24fad1596c589a58354307ba
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
