# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/coroutine2
    REF boost-1.82.0
    SHA512 1dc72e489c192954db5158e320bab164caa56880fa6f170906ee1d62e87c634809be947544a285701aa8c069d3c73acc90960209ad5e439d5927e7327e178c1d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
