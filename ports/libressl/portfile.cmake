if(EXISTS "${CURRENT_INSTALLED_DIR}/include/openssl/ssl.h")
  message(WARNING "Can't build libressl if openssl is installed. Please remove openssl, and try install libressl again if you need it. Build will continue since libressl is a subset of openssl")
  set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
  return()
endif()

set(LIBRESSL_VERSION 3.3.4)
set(LIBRESSL_HASH 11defdde8169d3653c24e149e698ffc5a8ead5ac0808111d1986cb11ef72e9912c463d4891d4635877021e73a8a045dbdbe5e83ec785a59150f170d2ca2031de)

vcpkg_download_distfile(
    LIBRESSL_SOURCE_ARCHIVE
    URLS https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${PORT}-${LIBRESSL_VERSION}.tar.gz https://ftp.fau.de/openbsd/LibreSSL/${PORT}-${LIBRESSL_VERSION}.tar.gz
    FILENAME ${PORT}-${LIBRESSL_VERSION}.tar.gz
    SHA512 ${LIBRESSL_HASH}
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${LIBRESSL_SOURCE_ARCHIVE}"
    REF ${LIBRESSL_VERSION}
    PATCHES
        0001-enable-ocspcheck-on-msvc.patch
        0002-suppress-msvc-warnings.patch
        0003-remove-restrict-define.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "tools" LIBRESSL_APPS
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DLIBRESSL_TESTS=OFF
    OPTIONS_DEBUG
        -DLIBRESSL_APPS=OFF
)

vcpkg_cmake_install()

if("tools" IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES ocspcheck openssl DESTINATION "${CURRENT_PACKAGES_DIR}/tools/openssl" AUTO_CLEAN)
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE
        "${CURRENT_PACKAGES_DIR}/bin"
        "${CURRENT_PACKAGES_DIR}/debug/bin"
    )
endif()
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/etc/ssl/certs"
    "${CURRENT_PACKAGES_DIR}/debug/etc/ssl/certs"
    "${CURRENT_PACKAGES_DIR}/share/man"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

if(VCPKG_TARGET_IS_WINDOWS OR VCPKG_TARGET_IS_UWP)
    file(GLOB_RECURSE LIBS "${CURRENT_PACKAGES_DIR}/*.lib")
    foreach(LIB ${LIBS})
        string(REGEX REPLACE "(.+)-[0-9]+\\.lib" "\\1.lib" LINK "${LIB}")
        execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink "${LIB}" "${LINK}")
    endforeach()
endif()
