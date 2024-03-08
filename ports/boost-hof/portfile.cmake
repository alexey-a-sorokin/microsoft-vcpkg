# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/hof
    REF boost-${VERSION}
    SHA512 cf0039d7c39521297b664f98f7d45a096df31fe889266d22a2a1305f620e786451e973324436bca52bced3e84a3106d4ce2d11792ff7896e2bba236bf2e7b1fd
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
