# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lockfree
    REF boost-${VERSION}
    SHA512 880fe93bbcbceb6ded3ca6471847db28a63b77704de1a977e396d68b7fabff6d66de97b5238037c317ced26b4607deaec4ceb7bc50c6ebb4165836a458421e21
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
