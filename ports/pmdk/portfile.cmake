include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY ONLY_DYNAMIC_CRT)

if (TRIPLET_SYSTEM_ARCH MATCHES "arm")
    message(FATAL_ERROR "ARM is currently not supported")
elseif (TRIPLET_SYSTEM_ARCH MATCHES "x86")
    message(FATAL_ERROR "x86 is not supported. Please use pmdk:x64-windows instead.")
endif()

set(PMDK_VERSION "1.7")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pmem/pmdk
    REF ${PMDK_VERSION}
    SHA512 ce6c36f0354c2272cc7258b190077d7655528c414128c937d8735854a083516f0a15340cebb16f3c0588835dc9b48501e04415a4d3e96887be5fcee5a3b90905
    HEAD_REF master
)

# Build only the selected projects
vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/src/PMDK.sln
    TARGET "Solution Items\\libpmem,Solution Items\\libpmemlog,Solution Items\\libpmemblk,Solution Items\\libpmemobj,Solution Items\\libpmempool,Solution Items\\libvmem,Solution Items\\Tools\\pmempool"
    OPTIONS /p:SRCVERSION=${PMDK_VERSION}
)

set(DEBUG_ARTIFACTS_PATH ${SOURCE_PATH}/src/x64/Debug)
set(RELEASE_ARTIFACTS_PATH ${SOURCE_PATH}/src/x64/Release)

# Install header files
file(GLOB HEADER_FILES ${SOURCE_PATH}/src/include/*.h)
file(INSTALL ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(GLOB HEADER_FILES ${SOURCE_PATH}/src/include/libpmemobj/*.h)
file(INSTALL ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/libpmemobj)

# Remove unneeded header files
file(REMOVE ${CURRENT_PACKAGES_DIR}/include/libvmmalloc.h)
file(REMOVE ${CURRENT_PACKAGES_DIR}/include/librpmem.h)

# Install libraries (debug)
file(GLOB LIB_DEBUG_FILES ${DEBUG_ARTIFACTS_PATH}/libs/libpmem*.lib)
file(INSTALL ${LIB_DEBUG_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/libpmemcommon.lib)
file(GLOB LIB_DEBUG_FILES ${DEBUG_ARTIFACTS_PATH}/libs/libpmem*.dll)
file(INSTALL ${LIB_DEBUG_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

# Install libraries (release)
file(GLOB LIB_RELEASE_FILES ${RELEASE_ARTIFACTS_PATH}/libs/libpmem*.lib)
file(INSTALL ${LIB_RELEASE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/libpmemcommon.lib)
file(GLOB LIB_RELEASE_FILES ${RELEASE_ARTIFACTS_PATH}/libs/libpmem*.dll)
file(INSTALL ${LIB_RELEASE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/bin)

# Install tools (release only)
file(INSTALL ${RELEASE_ARTIFACTS_PATH}/libs/pmempool.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/pmdk)

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/pmdk)

vcpkg_copy_pdbs()

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/pmdk)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pmdk/LICENSE ${CURRENT_PACKAGES_DIR}/share/pmdk/copyright)
