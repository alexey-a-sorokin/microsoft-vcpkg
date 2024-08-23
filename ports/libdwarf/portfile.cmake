vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO davea42/libdwarf-code
    REF "v${VERSION}"
    SHA512 8288db7a88ad7db7212fe524d5c877b1355b5a422c7fa95eee320f41f9f0f9f1c98500060986de8ebe5f1f6de36dd1a7017775168b0d140d82200da26c242c93
    HEAD_REF main
    PATCHES
        include-dir.diff # avoid dwarf.h conflict with elfutils
        dependencies.diff
        msvc-runtime.diff
        off_t.diff
        dwarfdump-conf.diff # no absolute paths
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" BUILD_NON_SHARED)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_NON_SHARED=${BUILD_NON_SHARED}
        -DBUILD_SHARED=${BUILD_SHARED}
    OPTIONS_DEBUG
        -DBUILD_DWARFDUMP=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/libdwarf")
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
vcpkg_copy_tools(TOOL_NAMES dwarfdump AUTO_CLEAN)

if(BUILD_SHARED)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libdwarf/libdwarf.h" "ifndef LIBDWARF_STATIC" "if 1")
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/share/libdwarf/Findzstd.cmake"
)

file(COPY_FILE "${SOURCE_PATH}/src/lib/libdwarf/COPYING" "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libdwarf COPYING")
file(COPY_FILE "${SOURCE_PATH}/src/bin/dwarfdump/COPYING" "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/dwarfdump COPYING")
file(COPY_FILE "${SOURCE_PATH}/src/bin/dwarfgen/COPYING" "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/dwarfgen COPYING")
vcpkg_install_copyright(FILE_LIST 
    "${SOURCE_PATH}/COPYING"
    "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libdwarf COPYING"
    "${SOURCE_PATH}/src/lib/libdwarf/LIBDWARFCOPYRIGHT"
    "${SOURCE_PATH}/src/lib/libdwarf/LGPL.txt"
    "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/dwarfdump COPYING"
    "${SOURCE_PATH}/src/bin/dwarfdump/DWARFDUMPCOPYRIGHT"
    "${SOURCE_PATH}/src/bin/dwarfdump/GPL.txt"
    "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/dwarfgen COPYING"
)
