vcpkg_from_bitbucket(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO multicoreware/x265_git
    REF 3.5 #v3.5
    SHA512 e95e454b438114cf90e32818847afa65b54caf69442a4a39dc92f125a7ec6f99c83ec509549ced3395cd5a77305abef0ecdad38b4a359f82fb17fce6c4c7cc7a
    HEAD_REF master
    PATCHES
        disable-install-pdb.patch
        fix-pkgconfig-version.patch
)

set(ASSEMBLY_OPTIONS "-DENABLE_ASSEMBLY=OFF")
if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_find_acquire_program(NASM)
    set(ASSEMBLY_OPTIONS "-DENABLE_ASSEMBLY=ON" "-DNASM_EXECUTABLE=${NASM}")
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" ENABLE_SHARED)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/source"
    OPTIONS
        ${ASSEMBLY_OPTIONS}
        -DENABLE_SHARED=${ENABLE_SHARED}
        -DENABLE_LIBNUMA=OFF
        -DX265_LATEST_TAG=3.4
    OPTIONS_DEBUG
        -DENABLE_CLI=OFF
    MAYBE_UNUSED_VARIABLES
        ENABLE_LIBNUMA
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_copy_tools(TOOL_NAMES x265 AUTO_CLEAN)

if(VCPKG_TARGET_IS_MINGW AND ENABLE_SHARED)
    file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/lib/libx265.a")
    file(REMOVE "${CURRENT_PACKAGES_DIR}/lib/libx265.a")
endif()

vcpkg_fixup_pkgconfig()
vcpkg_list(SET pc_files "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/x265.pc")
if(NOT VCPKG_BUILD_TYPE)
    vcpkg_list(APPEND pc_files "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/x265.pc")
endif()
foreach(FILE IN LISTS pc_files)
    file(READ "${FILE}" _contents)
    if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
        string(REPLACE "-lx265" "-lx265-static" _contents "${_contents}")
    else()
        string(REPLACE " -lgcc_s" "" _contents "${_contents}")
        string(REPLACE " -lgcc" "" _contents "${_contents}")
    endif()
    file(WRITE "${FILE}" "${_contents}")
endforeach()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
