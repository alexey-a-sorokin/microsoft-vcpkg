# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/ublas
    REF boost-${VERSION}
    SHA512 6c43726760060e0eb06558fc4fa09c4104f1051016e2a6bfc53d60c124030d3d3732c839b5482c2172be47414e550e6ebd6ad0849cab56d6ca9d2d75763811a0
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
