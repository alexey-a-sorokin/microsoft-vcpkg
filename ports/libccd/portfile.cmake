include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO danfis/libccd
    REF v2.1
    SHA512 ff037d9c4df50f09600cf9b3514b259b2850ff43f74817853f5665d22812891168f70bd3cc3969b2c9e3c706f6254991a65421476349607fbd04d894b217456d
    HEAD_REF master
    PATCHES  fix-uwp.patch
    
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/ccd)

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/pkgconfig TARGET_PATH share/${PORT})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include) 
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(INSTALL
    ${SOURCE_PATH}/BSD-LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_copy_pdbs()
