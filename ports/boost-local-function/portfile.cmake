# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/local_function
    REF boost-${VERSION}
    SHA512 4f2a9659a59f83e866f1575c3b701f5e0c7471ef6ee2fbd11100acd06ecbbf27e8e2c8184d7f9bcea5fc9f0ba5d30b8c12d2a884b7558a96dab135aea888eeeb
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
