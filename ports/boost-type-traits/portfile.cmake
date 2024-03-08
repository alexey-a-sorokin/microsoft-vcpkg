# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_traits
    REF boost-${VERSION}
    SHA512 637af2a4fb81a52ba1ca3f511bff020f1041f147fb5c2c74e9f734f6b3754a77f02fedd1896ee7887e255b6bc4c3217ff14d0b6731828fb9b3220b902b49386b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
