# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/chrono
    REF boost-${VERSION}
    SHA512 4fbd3b85fa63ee904e1134d35b676941f22e77d2d2d8b2a55527c27ce6187e45fefebe2327129850f374ccd37ec0a66e8323187e1bd616f6c73623e98076c027
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
