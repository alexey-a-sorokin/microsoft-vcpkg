set(PORT_VERSION 6.4.3)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO CoolProp/CoolProp
    REF 84897ce7a110a70ba2229e7a1f5d17ea03efd068 # v6.4.1
    SHA512 d231c1ad59479218dcfd165b3752b2fd3d8048342bbe1913af7253adcf3a72e869c916ca6005ebabe7d0010ebbed48c6d2cace618b8654a22e7db11a44d9eee9
    HEAD_REF master
    PATCHES
        fmt-fix.patch
        fix-builderror.patch
        fix-dependency.patch
        fix-install.patch
)

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR ${PYTHON3} DIRECTORY)
vcpkg_add_to_path(${PYTHON3_DIR})

file(REMOVE_RECURSE ${SOURCE_PATH}/externals)

# Patch up the file locations
file(COPY
    ${CURRENT_INSTALLED_DIR}/include/catch.hpp
    DESTINATION ${SOURCE_PATH}/externals/Catch/single_include
)

file(COPY
    ${CURRENT_INSTALLED_DIR}/include/eigen3/Eigen
    DESTINATION ${SOURCE_PATH}/externals/Eigen
)
file(COPY
    ${CURRENT_INSTALLED_DIR}/include/eigen3/unsupported/Eigen
    DESTINATION ${SOURCE_PATH}/externals/Eigen/unsupported
)

file(COPY
    ${CURRENT_INSTALLED_DIR}/include/rapidjson
    DESTINATION ${SOURCE_PATH}/externals/rapidjson/include
)

file(COPY
    ${CURRENT_INSTALLED_DIR}/include/IF97.h
    DESTINATION ${SOURCE_PATH}/externals/IF97
)

file(COPY
    ${CURRENT_INSTALLED_DIR}/include/msgpack.hpp
    ${CURRENT_INSTALLED_DIR}/include/msgpack
    DESTINATION ${SOURCE_PATH}/externals/msgpack-c/include
)

file(COPY
    ${CURRENT_INSTALLED_DIR}/include/fmt
    DESTINATION ${SOURCE_PATH}/externals/cppformat
)

file(COPY
    ${CURRENT_INSTALLED_DIR}/include/REFPROP_lib.h
    DESTINATION ${SOURCE_PATH}/externals/REFPROP-headers/
)

# Use a nasty hack to include the correct header
file(APPEND
    ${SOURCE_PATH}/externals/msgpack-c/include/fmt/format.h
    "#include \"fmt/printf.h\""
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" COOLPROP_SHARED_LIBRARY)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" COOLPROP_STATIC_LIBRARY)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "dynamic" COOLPROP_MSVC_DYNAMIC)
string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" COOLPROP_MSVC_STATIC)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCOOLPROP_SHARED_LIBRARY=${COOLPROP_SHARED_LIBRARY}
        -DCOOLPROP_STATIC_LIBRARY=${COOLPROP_STATIC_LIBRARY}
        -DCOOLPROP_MSVC_DYNAMIC=${COOLPROP_MSVC_DYNAMIC}
        -DCOOLPROP_MSVC_STATIC=${COOLPROP_MSVC_STATIC}
    OPTIONS_RELEASE
        -DCOOLPROP_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}
    OPTIONS_DEBUG
        -DCOOLPROP_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}/debug
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if (VCPKG_TARGET_IS_WINDOWS AND COOLPROP_SHARED_LIBRARY)
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/CoolPropLib.h
        "#if defined(COOLPROP_LIB)" "#if 1"
    )
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
