# Github config
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO JustWhit3/osmanip
    REF "v${VERSION}"
    SHA512 17012ebfc06455a933d2acb53cf64ee6b5b452daaed0995b2a0a3e4eee926e819ce7d0d7c83425a484a77fc9919833dbf8d1948d3758c063a89affe1ab83cc82
    HEAD_REF main
)

# Main commands
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)
vcpkg_cmake_install()

# Move cmake configs
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/osmanip)

# Install license
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
