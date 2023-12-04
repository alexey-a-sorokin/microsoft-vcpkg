# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/spirit
    REF boost-1.83.0
    SHA512 965bc3a4e9306766d3bf0c5315460bcdaf6c0699277694b52f0f58070c26b754e07143ae019f71a6c388ed1c8bad1f43b643d66e4a8e88805bd3cee77e56dd69
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
