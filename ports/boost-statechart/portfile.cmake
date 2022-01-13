# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/statechart
    REF boost-1.78.0
    SHA512 81f9148126b2dc09f2e51cc2607247a1bf3f099d87f4c402ca47543a6339c0da0139040e28c4465030e0056aeb7e3e160926b3a7e49b4f91faf8275e63715e27
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/vcpkg-boost-copy/vcpkg_boost_copy_headers.cmake)
vcpkg_boost_copy_headers(SOURCE_PATH ${SOURCE_PATH})
