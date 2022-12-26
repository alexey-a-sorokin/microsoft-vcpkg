vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO netheril96/StaticJSON
    REF 300f0697616e6794aa74c123411028f0c42011c4
    SHA512 b19d8eeb518a6d32784dd4c2b7d7c6b80cfdb02a7159993c186139d1843e5180232fe999b126b39d0296e21f0c0800f70cfb58822e99fb9073052405d014feed
    HEAD_REF master
)
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH} OPTIONS -DSTATICJSON_ENABLE_TEST=OFF)
vcpkg_cmake_install()
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
