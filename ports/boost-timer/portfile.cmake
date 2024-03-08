# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/timer
    REF boost-${VERSION}
    SHA512 fd4c563794d67597f6cf71f4306e76b4205c5994183f95c451abbb7a41d2821898b7f98317d7d213490165d700b8264abc0d016f7e67118cfdc0ae06b61f93fe
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
