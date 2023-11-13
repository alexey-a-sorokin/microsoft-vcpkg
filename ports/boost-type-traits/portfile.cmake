# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_traits
    REF boost-1.83.0
    SHA512 8763b4f8d2eecade2092ae69503be82c5845804d5ccf8788c412f48b708d517c24c63244905700a8c018c847410f60bafa8803ae0e7dcd1b52506be210ce9635
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
