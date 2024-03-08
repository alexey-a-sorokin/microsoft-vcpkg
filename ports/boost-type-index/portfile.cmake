# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_index
    REF boost-${VERSION}
    SHA512 37c7bcfddbc79a0b3b6c866fd11153b049fc1758812da3d32bba23f24abd4db735bce038f755e983824951302208ec9ed10d0b3e5cd21b2d18cb683842d646bd
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
