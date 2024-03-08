# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/program_options
    REF boost-${VERSION}
    SHA512 ffd8cc5a8f18d173ef217082637dddfef650fdb061de0ee349352d90b138ff53b3893a44c093c005ae105430b3fd5ffcd31842c08c59779b141ab8307ade49a2
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
