set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO oneapi-src/oneTBB
    REF v2021.5.0
    SHA512 0e7b71022e397a6d7abb0cea106847935ae79a1e12a6976f8d038668c6eca8775ed971202c5bd518f7e517092b67af805cc5feb04b5c3a40e9fbf972cc703a46
    HEAD_REF onetbb_2021
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DTBB_TEST=OFF
        -DTBB_STRICT=OFF
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/TBB)
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/share/doc
    ${CURRENT_PACKAGES_DIR}/debug/include
    ${CURRENT_PACKAGES_DIR}/debug/share
    # These are duplicate libraries provided on Windows -- users should use the tbb12 libraries instead
    ${CURRENT_PACKAGES_DIR}/lib/tbb.lib
    ${CURRENT_PACKAGES_DIR}/debug/lib/tbb_debug.lib
)

file(READ "${CURRENT_PACKAGES_DIR}/share/tbb/TBBConfig.cmake" _contents)
file(WRITE "${CURRENT_PACKAGES_DIR}/share/tbb/TBBConfig.cmake" "
include(CMakeFindDependencyMacro)
find_dependency(Threads)
${_contents}")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
