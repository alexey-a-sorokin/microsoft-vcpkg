# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/metaparse
    REF boost-${VERSION}
    SHA512 da82b2f0ea9afd553382d15d1668685cacab2190f491c5f7a26f15591f05c1be88168713ca47618907b9bd8f9eea66c589af5ab67a0146e8def43d6b66e4de2e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
