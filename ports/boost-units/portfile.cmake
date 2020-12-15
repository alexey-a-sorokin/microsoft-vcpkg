# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/units
    REF boost-1.74.0
    SHA512 f42db9dbd0c4a9ed9e4585b6a12b6864e0d5b82a965256cd9bcf099ac0616f1879f305c6b36decd7bc93a8019af7cb1612f488009ec3c9408c249ea76c1d6c1b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
