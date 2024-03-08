# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/function
    REF boost-${VERSION}
    SHA512 78e14f41fc0799ffe1641353716899a2543d7a476360a11adfcdefc63d5710cf1d08d532bbba3eadf10735c147047ef9832fada2ace385b4d7e7a787b083fde2
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
