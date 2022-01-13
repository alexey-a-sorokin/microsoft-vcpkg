# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_index
    REF boost-1.78.0
    SHA512 d57bc583f6d601835c5887e99e46a388144d3a8074fa7bb01cee11bad4c5ec82f88722867448d01c4c6b899601b9675e6d45ab93f7c5c6416d3894e2fa3c2ebc
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/vcpkg-boost-copy/vcpkg_boost_copy_headers.cmake)
vcpkg_boost_copy_headers(SOURCE_PATH ${SOURCE_PATH})
