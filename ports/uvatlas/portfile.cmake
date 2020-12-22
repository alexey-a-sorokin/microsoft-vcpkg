vcpkg_check_linkage(ONLY_STATIC_LIBRARY ONLY_DYNAMIC_CRT)

vcpkg_fail_port_install(ON_TARGET "OSX" "Linux")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/UVAtlas
    REF dec2020b
    SHA512 2b919f8f7911b095a12608ad2904ee230fc9a9d647bf78d3187d2619d2130b9cbeb9aa592b195781531cb86ade0efef564416ce0891f8175a44f9aaaffc081c4
    HEAD_REF master
)

if(NOT VCPKG_TARGET_IS_UWP)
  set(FEATURE_OPTIONS -DBUILD_TOOLS=ON)
else()
  set(FEATURE_OPTIONS -DBUILD_TOOLS=OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${FEATURE_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH cmake)

if(NOT VCPKG_TARGET_IS_UWP)
  vcpkg_copy_tools(
        TOOL_NAMES uvatlastool
        SEARCH_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/bin/CMake
    )

elseif((VCPKG_HOST_IS_WINDOWS) AND (VCPKG_TARGET_ARCHITECTURE MATCHES x64))
  vcpkg_download_distfile(uvatlastool
    URLS "https://github.com/Microsoft/UVAtlas/releases/download/dec2020/uvatlastool.exe"
    FILENAME "uvatlastool.exe"
    SHA512 f3388e590bb45281a089d6d38ff603e99f2ff9124ec1e6caebae2663e4ab8ccaf06f5cce671f78ed9a1f882c6d2e2b1188212ef0219f96b46872faa20cc649fd
  )

  file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/uvatlas/")

  file(INSTALL
    ${DOWNLOADS}/uvatlastool.exe
    DESTINATION ${CURRENT_PACKAGES_DIR}/tools/uvatlas/)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
