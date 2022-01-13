# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_map_parallel
    REF boost-1.78.0
    SHA512 f6c734ca16b19d249a6b6ee66348f9671ee1f3bbb3a33ac8872e236781ecd2139df4c8c77b7bca89c51df973ee84de254ae01c892770a5caa365571ab5e8e852
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/vcpkg-boost-copy/vcpkg_boost_copy_headers.cmake)
vcpkg_boost_copy_headers(SOURCE_PATH ${SOURCE_PATH})
