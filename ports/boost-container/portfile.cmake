# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/container
    REF boost-${VERSION}
    SHA512 566469c28670f080388e9d763115ce9e344e524aadf2754d71af4d604d0edacb37306f714ac86d00220faa74bda4fc8a7d953391eba9894b303c14d010ed0c6c
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
