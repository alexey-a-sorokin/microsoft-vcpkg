# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/multi_array
    REF boost-${VERSION}
    SHA512 410542c8e6e4defecdc57298ff5d7a16dab935c2ee41a364cb4379b5b8415272f2e00cf6ea22ec4688c0c96949bcb11d4c6579b1748f5ce358a3727b27fea17b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
