vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jemalloc/jemalloc-cmake
    REF jemalloc-cmake.4.3.1
    SHA512 e94b62ec3a53acc0ab5acb247d7646bc172108e80f592bb41c2dd50d181cbbeb33d623adf28415ffc0a0e2de3818af2dfe4c04af75ac891ef5042bc5bb186886
    HEAD_REF master
    PATCHES
        fix-cmakelists.patch
        fix-utilities.patch
        fix-static-build.patch
        Export-unofficial-jemalloc-config.patch
)

if (VCPKG_CRT_LINKAGE STREQUAL "dynamic")
    set(BUILD_STATIC_LIBRARY OFF)
else()
    set(BUILD_STATIC_LIBRARY ON)
endif()

vcpkg_cmake_configure(
    DISABLE_PARALLEL_CONFIGURE
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DGIT_FOUND=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
        -Dwithout-export=${BUILD_STATIC_LIBRARY}
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-jemalloc)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
