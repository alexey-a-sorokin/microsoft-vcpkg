# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/range
    REF boost-${VERSION}
    SHA512 9b9694b8f42755e95ac06981a47282d83cc0bb30cd95943939b3d9799f7675a4d3d6949280f8856305c9f11b7a5684950971e133db55f3bdfad7482d6fb247d7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
