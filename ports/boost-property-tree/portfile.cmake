# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_tree
    REF boost-${VERSION}
    SHA512 a0379ca2b4b68cd8e4a5a94c33f4ba6105ac8829b223aaac746b6e45e96d70c8f36b560dd63d2e4ef0da16021a85cbf9fdf640a8b566d50c7c968910497c8a4e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
