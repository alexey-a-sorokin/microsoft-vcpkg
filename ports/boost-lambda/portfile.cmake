# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lambda
    REF boost-1.79.0
    SHA512 4baa279ae5ba4a0b63c3177bebb30a15f539f56e8786a4049a027a6593c73a07f6d397b3bdc07fedaa0407015a7320f1577a499ba463c8bfdb13d1fdad2394b7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
