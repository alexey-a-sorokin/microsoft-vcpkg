# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/metaparse
    REF boost-1.78.0
    SHA512 d068680be7609e3a9c87f8c027373eb68fe3c212944fe63369bca94842fd8ceb032a43a455a93248bf5578170acdb76c99aa1d04abc53901636d8e74c261755c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/vcpkg-boost-copy/vcpkg_boost_copy_headers.cmake)
vcpkg_boost_copy_headers(SOURCE_PATH ${SOURCE_PATH})
