# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/variant2
    REF boost-${VERSION}
    SHA512 07440809c424b1a81a24b25729677c56f68eeb37a10e39f16eb49f11ee3c74e0caecade4e921a60e592be492f8efc86cd93bdcf830e610e350baa83ded7f2a09
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
