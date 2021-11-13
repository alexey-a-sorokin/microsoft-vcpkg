if (EXISTS "${CURRENT_INSTALLED_DIR}/share/libmysql")
    message(FATAL_ERROR "FATAL ERROR: libmysql and libmariadb are incompatible.")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mariadb-corporation/mariadb-connector-c
    REF b2bb1b213c79169b7c994a99f21f47f11be465d4 # v3.1.15
    SHA512 51ebd2e9fd505eebc7691c60fe0b86cfc5368f8b370fba6c3ec8f5514319ef1e0de4910ad5e093cd7d5e5c7782120e22e8c85c94af9389fa4e240cedf012d755
    HEAD_REF 3.1
    PATCHES
        arm64.patch
        md.patch
        disable-test-build.patch
        fix-InstallPath.patch
        fix-iconv.patch
        export-cmake-targets.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES 
        zlib WITH_EXTERNAL_ZLIB
        iconv WITH_ICONV
)

if("openssl" IN_LIST FEATURES)
    set(WITH_SSL OPENSSL)
else()
    set(WITH_SSL OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DINSTALL_PLUGINDIR=plugins/${PORT}
        -DWITH_UNIT_TESTS=OFF
        -DWITH_CURL=OFF
        -DWITH_SSL=${WITH_SSL}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-libmariadb)

vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if (NOT VCPKG_TARGET_IS_WINDOWS)
    vcpkg_copy_tools(TOOL_NAMES mariadb_config AUTO_CLEAN)
endif()

# copy & remove header files
file(REMOVE
    "${CURRENT_PACKAGES_DIR}/include/mariadb/my_config.h.in"
    "${CURRENT_PACKAGES_DIR}/include/mariadb/mysql_version.h.in"
    "${CURRENT_PACKAGES_DIR}/include/mariadb/CMakeLists.txt"
    "${CURRENT_PACKAGES_DIR}/include/mariadb/Makefile.am"
)
file(RENAME "${CURRENT_PACKAGES_DIR}/include/mariadb" "${CURRENT_PACKAGES_DIR}/include/mysql")

# copy license file
file(INSTALL "${SOURCE_PATH}/COPYING.LIB" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
