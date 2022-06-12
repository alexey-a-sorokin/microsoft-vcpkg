# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/function_types
    REF boost-1.79.0
    SHA512 95fbe35406c1276a8170b7f83dcdc7285ee04ee2e14329544cbb2ccb3a8a24d05ca7cd2b762f88223505f4c4b379a523068492e625c58bb8eb961a6333966019
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
