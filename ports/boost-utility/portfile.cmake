# Automatically generated by scripts/boost/generate-ports.ps1
vcpkg_minimum_required(VERSION 2022-10-12)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/utility
    REF boost-${VERSION}
    SHA512 aa3feff78e71ec696101b922acdea3d0fd5dc6acf0a9aff93c9169404a9b1e34d00c7427d52138b96efe0dc23206f32761cf6e354dd81d950eed467553d9ecc7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
