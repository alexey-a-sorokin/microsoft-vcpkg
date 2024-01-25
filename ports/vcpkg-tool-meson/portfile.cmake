# This port represents a dependency on the Meson build system.
# In the future, it is expected that this port acquires and installs Meson.
# Currently is used in ports that call vcpkg_find_acquire_program(MESON) in order to force rebuilds.

set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

set(program MESON)
set(program_version 0.63.0)
set(program_name meson)
set(search_names meson meson.py)
set(interpreter PYTHON3)
set(apt_package_name "meson")
set(brew_package_name "meson")
set(paths_to_search "${CURRENT_PACKAGES_DIR}/tools/meson")
set(supported_on_unix ON)
set(version_command --version)
set(extra_search_args EXACT_VERSION_MATCH)

vcpkg_find_acquire_program(PYTHON3)

# Reenable if no patching of meson is required within vcpkg
# z_vcpkg_find_acquire_program_find_external("${program}"
#    ${extra_search_args}
#    PROGRAM_NAME "${program_name}"
#    MIN_VERSION "${program_version}"
#    INTERPRETER "${interpreter}"
#    NAMES ${search_names}
#    VERSION_COMMAND ${version_command}
# )

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mesonbuild/meson
    REF "${VERSION}"
    SHA512 95a3146c88719c6c02b07c7b5f0930057140f9d6f3b3eddbc32f47080e7ddcce5f2903f607616eb8b42dad86b2c33e906ced7352ad31995fc644dbe69f81b90e
    PATCHES
        meson-intl.patch
        remove-freebsd-pcfile-specialization.patch
)

vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}"
        "-DSOURCE_PATH=${SOURCE_PATH}"
        "-DCURRENT_PACKAGES_DIR=${CURRENT_PACKAGES_DIR}"
        -P "${CURRENT_PORT_DIR}/install.cmake"
    WORKING_DIRECTORY "${VCPKG_ROOT_DIR}"
    LOGNAME install
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/vcpkg-port-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

z_vcpkg_find_acquire_program_find_internal("${program}"
    INTERPRETER "${interpreter}"
    PATHS ${paths_to_search}
    NAMES ${search_names}
)

message(STATUS "Using meson: ${MESON}")
file(WRITE "${CURRENT_PACKAGES_DIR}/share/meson/version.txt" "${program_version}") # For vcpkg_find_acquire_program
