find_path(ZLIB_INCLUDE_DIR NAMES zlib.h PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include" NO_DEFAULT_PATH)
find_library(ZLIB_LIBRARY_RELEASE NAMES zlib  z PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib" NO_DEFAULT_PATH)
find_library(ZLIB_LIBRARY_DEBUG   NAMES zlibd z PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/debug/lib" NO_DEFAULT_PATH)
if(NOT ZLIB_INCLUDE_DIR OR NOT (ZLIB_LIBRARY_RELEASE OR ZLIB_LIBRARY_DEBUG))
    message(FATAL_ERROR "Broken installation of vcpkg port zlib")
endif()
if(CMAKE_VERSION VERSION_LESS 3.4)
    include(SelectLibraryConfigurations)
    select_library_configurations(ZLIB)
    unset(ZLIB_FOUND)
endif()
_find_package(${ARGS})

# To conform with cmake's find script interface,
# ensure that not just
#   ZLIB_INCLUDE_DIR
# is set, but also
#   ZLIB_INCLUDE_DIRS
if (NOT DEFINED ${ZLIB_INCLUDE_DIRS})
    set(ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR})
endif()

