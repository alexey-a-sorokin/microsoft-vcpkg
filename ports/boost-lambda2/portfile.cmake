# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lambda2
    REF boost-${VERSION}
    SHA512 6f64f262f75c394d69370f09f72de53e13cca9e5836f3feea4ba51b85ec6d6d50017c5c0d3822f2859db239f3e3eb199446902359155d999b6d159bc75793578
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
