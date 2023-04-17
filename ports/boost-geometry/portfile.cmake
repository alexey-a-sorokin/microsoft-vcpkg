# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/geometry
    REF boost-1.82.0
    SHA512 e03a2a1f15dfe140e3fd6fc3725386c094c7d8b1248c713f9530a5b7735d025c7282426adc1de62aa60fe305289605e0f0826936e6b976102f54695f6c4368d5
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
