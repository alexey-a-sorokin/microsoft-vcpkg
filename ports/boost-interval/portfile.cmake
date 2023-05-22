# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/interval
    REF boost-1.82.0
    SHA512 5de7ac82c0e37ec7ed298686b7ab8050bb568e4ea246ef766a299acfa715dbb6e245e7722a7be3d525543113a16f0fb691b03861c1a0cdd97b7aa51c8080dc9f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
