include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO winsoft666/ppxnet
    REF v1.10
    SHA512 de2a1ee32a182a3aba9c3c83f391eb65c04c41a8670571b7199bbcdd75eceb7754c7c0016b018b6c25e556cd7eef85dbb60cc4b8469987f6f171e289d873c826
    HEAD_REF master
)


if("${VCPKG_LIBRARY_LINKAGE}" STREQUAL "static")
	set(BUILD_SHARED_LIBS OFF)
else()
	set(BUILD_SHARED_LIBS ON)
endif()


vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -DBUILD_TESTS=OFF
	OPTIONS_RELEASE
	OPTIONS_DEBUG
)

vcpkg_install_cmake()

if(EXISTS ${CURRENT_PACKAGES_DIR}/lib/cmake/ppxnet)
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/ppxnet)
elseif(EXISTS ${CURRENT_PACKAGES_DIR}/share/ppxnet)
    vcpkg_fixup_cmake_targets(CONFIG_PATH share/ppxnet)
endif()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/ppxnet RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()

file(COPY ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})

