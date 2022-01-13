# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lambda2
    REF boost-1.78.0
    SHA512 56c8e14dea12e32d8b049c6de2c5ed4ea299b169fc43d76c65aa1057dc5cad9e1182fdf9761381855c3b940ed4e34a794ea8aeca11fde116bc25c4ae1065cc58
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/vcpkg-boost-copy/vcpkg_boost_copy_headers.cmake)
vcpkg_boost_copy_headers(SOURCE_PATH ${SOURCE_PATH})
