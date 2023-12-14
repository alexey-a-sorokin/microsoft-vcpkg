# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/callable_traits
    REF boost-${VERSION}
    SHA512 02f292919eaa6fbb3dbdc3a169cf4945777d96624d40084a3ef145a379de37058d9f125f6e60ac99e1154babac9bf596a68119d9e88d47311d5eba68e2a13cb8
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
