vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO facebook/wangle
    REF "v${VERSION}"
    SHA512 46adf203677aef71aefb57d13e08dad2c69f13e94880966469835f4fbf238b9c3cbb8c1cedb6c4150414f6c9e0a36cdfb0adc5805f620055056a6b24cb6795eb
    HEAD_REF master
    PATCHES
        fix-config-cmake.patch
        fix_dependency.patch
)

file(REMOVE
  "${SOURCE_PATH}/wangle/cmake/FindDoubleConversion.cmake"
  "${SOURCE_PATH}/build/fbcode_builder/CMake/FindGflags.cmake"
  "${SOURCE_PATH}/build/fbcode_builder/CMake/FindGlog.cmake"
  "${SOURCE_PATH}/build/fbcode_builder/CMake/FindGMock.cmake"
  "${SOURCE_PATH}/build/fbcode_builder/CMake/FindLibEvent.cmake"
  "${SOURCE_PATH}/build/fbcode_builder/CMake/FindSodium.cmake"
  "${SOURCE_PATH}/build/fbcode_builder/CMake/FindZstd.cmake"
)


vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/wangle"
    OPTIONS
        -DBUILD_TESTS=OFF
        -DBUILD_EXAMPLES=OFF
        -DINCLUDE_INSTALL_DIR:STRING=include
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/wangle)

file(READ "${CURRENT_PACKAGES_DIR}/share/wangle/wangle-targets.cmake" _contents)
STRING(REPLACE "\${_IMPORT_PREFIX}/lib/" "\${_IMPORT_PREFIX}/\$<\$<CONFIG:DEBUG>:debug/>lib/" _contents "${_contents}")
STRING(REPLACE "\${_IMPORT_PREFIX}/debug/lib/" "\${_IMPORT_PREFIX}/\$<\$<CONFIG:DEBUG>:debug/>lib/" _contents "${_contents}")
file(WRITE "${CURRENT_PACKAGES_DIR}/share/wangle/wangle-targets.cmake" "${_contents}")

vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/include/wangle/util/test"
    "${CURRENT_PACKAGES_DIR}/include/wangle/ssl/test/certs"
    "${CURRENT_PACKAGES_DIR}/include/wangle/service/test"
    "${CURRENT_PACKAGES_DIR}/include/wangle/deprecated/rx/test"
)

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
