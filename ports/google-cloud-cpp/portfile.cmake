if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    message(STATUS "Warning: Dynamic building not supported yet. Building static.")
    set(VCPKG_LIBRARY_LINKAGE static)
endif()

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GoogleCloudPlatform/google-cloud-cpp
    REF v0.1.0-pre1
    SHA512 a43feb5a93f8912124b594399238870dd9740726d5ef1ad02532e197656c83c55228c1da1f4a45e4010508d1cae25495c959aa7fe4b6e7d3b7bfb60b74756dbf
    HEAD_REF master
)

set(GOOGLEAPIS_VERSION 92f10d7033c6fa36e1a5a369ab5aa8bafd564009)
vcpkg_download_distfile(GOOGLEAPIS
    URLS "https://github.com/google/googleapis/archive/92f10d7033c6fa36e1a5a369ab5aa8bafd564009.zip"
    FILENAME "googleapis-${GOOGLEAPIS_VERSION}.zip"
    SHA512 4280ece965a231f6a0bb3ea38a961d15babd9eac517f9b0d57e12f186481bbab6a27e4f0ee03ba3c587c9aa93d3c2e6c95f67f50365c65bb10594f0229279287
)

file(REMOVE_RECURSE ${SOURCE_PATH}/third_party)
vcpkg_extract_source_archive(${GOOGLEAPIS} ${SOURCE_PATH}/third_party)
file(RENAME ${SOURCE_PATH}/third_party/googleapis-${GOOGLEAPIS_VERSION} ${SOURCE_PATH}/third_party/googleapis)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DGOOGLE_CLOUD_CPP_GRPC_PROVIDER=vcpkg
        -DGOOGLE_CLOUD_CPP_GMOCK_PROVIDER=vcpkg
)

vcpkg_install_cmake(ADD_BIN_TO_PATH)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/bigtable/client/testing)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_fixup_cmake_targets(CONFIG_PATH share/cmake TARGET_PATH share/bigtable_client)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/google-cloud-cpp RENAME copyright)

vcpkg_copy_pdbs()
