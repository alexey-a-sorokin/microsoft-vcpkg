# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/poly_collection
    REF boost-1.76.0
    SHA512 9bc910a72b232e8615d43e967f5a19d2b5910dcaf1641c71b9bbc67ea72e8fb96a834fab8657bce89be574ec9d56e298cb8f36d7663476a5604876fba6ae1cde
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
