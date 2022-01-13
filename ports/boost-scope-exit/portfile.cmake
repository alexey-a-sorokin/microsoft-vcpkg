# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/scope_exit
    REF boost-1.78.0
    SHA512 53e3f418727d80895e35cb483bcf2358e82c2ff221a0138e292dcd0648cf1b7065cd3dcbbb69d33b04ae0671b0d23038bedf6ad20e81bf4a8af4ab8b2e28e918
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/vcpkg-boost-copy/vcpkg_boost_copy_headers.cmake)
vcpkg_boost_copy_headers(SOURCE_PATH ${SOURCE_PATH})
