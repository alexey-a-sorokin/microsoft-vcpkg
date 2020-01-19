cmake_minimum_required(VERSION 3.5)

macro(debug_message)
    if(DEFINED PORT_DEBUG AND PORT_DEBUG)
        message(STATUS "[DEBUG] ${ARGN}")
    endif()
endmacro()

#Detect .vcpkg-root to figure VCPKG_ROOT_DIR, starting from triplet folder.
set(VCPKG_ROOT_DIR_CANDIDATE ${CMAKE_CURRENT_LIST_DIR})

if(DEFINED VCPKG_ROOT_PATH)
    set(VCPKG_ROOT_DIR_CANDIDATE ${VCPKG_ROOT_PATH})
else()
    message(FATAL_ERROR [[
        Your vcpkg executable is outdated and is not compatible with the current CMake scripts.
        Please re-build vcpkg by running bootstrap-vcpkg.
    ]])
endif()

# fixup Windows drive letter to uppercase.
get_filename_component(VCPKG_ROOT_DIR_CANDIDATE ${VCPKG_ROOT_DIR_CANDIDATE} ABSOLUTE)

# Validate VCPKG_ROOT_DIR_CANDIDATE
if (NOT EXISTS "${VCPKG_ROOT_DIR_CANDIDATE}/.vcpkg-root")
    message(FATAL_ERROR "Could not find .vcpkg-root")
endif()

set(VCPKG_ROOT_DIR ${VCPKG_ROOT_DIR_CANDIDATE})

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
set(CURRENT_INSTALLED_DIR ${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET} CACHE PATH "Location to install final packages")
set(DOWNLOADS ${VCPKG_ROOT_DIR}/downloads CACHE PATH "Location to download sources and tools")
set(SCRIPTS ${CMAKE_CURRENT_LIST_DIR} CACHE PATH "Location to stored scripts")
set(PACKAGES_DIR ${VCPKG_ROOT_DIR}/packages CACHE PATH "Location to store package images")
set(BUILDTREES_DIR ${VCPKG_ROOT_DIR}/buildtrees CACHE PATH "Location to perform actual extract+config+build")

if(PORT)
    set(CURRENT_BUILDTREES_DIR ${BUILDTREES_DIR}/${PORT})
    set(CURRENT_PACKAGES_DIR ${PACKAGES_DIR}/${PORT}_${TARGET_TRIPLET})
endif()


if(CMD MATCHES "^BUILD$")
    set(CMAKE_TRIPLET_FILE ${TARGET_TRIPLET_FILE})
    if(NOT EXISTS ${CMAKE_TRIPLET_FILE})
        message(FATAL_ERROR "Unsupported target triplet. Triplet file does not exist: ${CMAKE_TRIPLET_FILE}")
    endif()

    if(NOT DEFINED CURRENT_PORT_DIR)
        message(FATAL_ERROR "CURRENT_PORT_DIR was not defined")
    endif()
    set(TO_CMAKE_PATH "${CURRENT_PORT_DIR}" CURRENT_PORT_DIR)
    if(NOT EXISTS ${CURRENT_PORT_DIR})
        message(FATAL_ERROR "Cannot find port: ${PORT}\n  Directory does not exist: ${CURRENT_PORT_DIR}")
    endif()
    if(NOT EXISTS ${CURRENT_PORT_DIR}/portfile.cmake)
        message(FATAL_ERROR "Port is missing portfile: ${CURRENT_PORT_DIR}/portfile.cmake")
    endif()
    if(NOT EXISTS ${CURRENT_PORT_DIR}/CONTROL)
        message(FATAL_ERROR "Port is missing control file: ${CURRENT_PORT_DIR}/CONTROL")
    endif()

    unset(PACKAGES_DIR)
    unset(BUILDTREES_DIR)

    if(EXISTS ${CURRENT_PACKAGES_DIR})
        file(GLOB FILES_IN_CURRENT_PACKAGES_DIR "${CURRENT_PACKAGES_DIR}/*")
        if(FILES_IN_CURRENT_PACKAGES_DIR)
            file(REMOVE_RECURSE ${FILES_IN_CURRENT_PACKAGES_DIR})
            file(GLOB FILES_IN_CURRENT_PACKAGES_DIR "${CURRENT_PACKAGES_DIR}/*")
            if(FILES_IN_CURRENT_PACKAGES_DIR)
                message(FATAL_ERROR "Unable to empty directory: ${CURRENT_PACKAGES_DIR}\n  Files are likely in use.")
            endif()
        endif()
    endif()
    file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR} ${CURRENT_PACKAGES_DIR})

    include(${CMAKE_TRIPLET_FILE})

    if (DEFINED VCPKG_ENV_OVERRIDES_FILE)
        include(${VCPKG_ENV_OVERRIDES_FILE})
    endif()

    if (DEFINED VCPKG_PORT_TOOLCHAINS)
        foreach(VCPKG_PORT_TOOLCHAIN ${VCPKG_PORT_TOOLCHAINS})
            include(${VCPKG_PORT_TOOLCHAIN})
        endforeach()
    endif()

    set(TRIPLET_SYSTEM_ARCH ${VCPKG_TARGET_ARCHITECTURE})
    include(${SCRIPTS}/cmake/vcpkg_common_definitions.cmake)
    include(${SCRIPTS}/cmake/vcpkg_common_functions.cmake)
    include(${CURRENT_PORT_DIR}/portfile.cmake)

    set(BUILD_INFO_FILE_PATH ${CURRENT_PACKAGES_DIR}/BUILD_INFO)
    file(WRITE  ${BUILD_INFO_FILE_PATH} "CRTLinkage: ${VCPKG_CRT_LINKAGE}\n")
    file(APPEND ${BUILD_INFO_FILE_PATH} "LibraryLinkage: ${VCPKG_LIBRARY_LINKAGE}\n")

    if (DEFINED VCPKG_POLICY_DLLS_WITHOUT_LIBS)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyDLLsWithoutLIBs: ${VCPKG_POLICY_DLLS_WITHOUT_LIBS}\n")
    endif()
    if (DEFINED VCPKG_POLICY_DLLS_WITHOUT_EXPORTS)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyDLLsWithoutExports: ${VCPKG_POLICY_DLLS_WITHOUT_EXPORTS}\n")
    endif()
    if (DEFINED VCPKG_POLICY_EMPTY_PACKAGE)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyEmptyPackage: ${VCPKG_POLICY_EMPTY_PACKAGE}\n")
    endif()
    if (DEFINED VCPKG_POLICY_ONLY_RELEASE_CRT)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyOnlyReleaseCRT: ${VCPKG_POLICY_ONLY_RELEASE_CRT}\n")
    endif()
    if (DEFINED VCPKG_POLICY_ALLOW_OBSOLETE_MSVCRT)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyAllowObsoleteMsvcrt: ${VCPKG_POLICY_ALLOW_OBSOLETE_MSVCRT}\n")
    endif()
    if (DEFINED VCPKG_POLICY_EMPTY_INCLUDE_FOLDER)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyEmptyIncludeFolder: ${VCPKG_POLICY_EMPTY_INCLUDE_FOLDER}\n")
    endif()
    if (DEFINED VCPKG_HEAD_VERSION)
        file(APPEND ${BUILD_INFO_FILE_PATH} "Version: ${VCPKG_HEAD_VERSION}\n")
    endif()
elseif(CMD MATCHES "^CREATE$")
    file(TO_NATIVE_PATH ${VCPKG_ROOT_DIR} NATIVE_VCPKG_ROOT_DIR)
    file(TO_NATIVE_PATH ${DOWNLOADS} NATIVE_DOWNLOADS)
    if(EXISTS ports/${PORT}/portfile.cmake)
        message(FATAL_ERROR "Portfile already exists: '${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}\\portfile.cmake'")
    endif()
    
    # Download with git needn't SHA512
    if (NOT DOWNLOAD_WITH_GIT)
        if (DOWNLOAD_WITH_GITHUB)
            string(REGEX REPLACE "(\\.(zip|gz|tar|tgz|bz2))+\$" "" TMP_FILENAME ${FILENAME})
            string(REGEX REPLACE ".+/(.+)/.+$" "\\1" ORG_NAME ${URL})
            string(REGEX REPLACE ".+/.+/(.+)$" "\\1" REPO_NAME ${URL})
            set(TMP_URL "${URL}/archive/${TMP_FILENAME}.tar.gz")
            set(TMP_FILENAME "${ORG_NAME}-${REPO_NAME}-${TMP_FILENAME}.tar.gz")
        elseif (DOWNLOAD_WITH_URL)
            set(TMP_FILENAME ${FILENAME})
            string(REGEX REPLACE "(\\.(zip|gz|tar|tgz|bz2))+\$" "" ROOT_NAME ${FILENAME})
            set(TMP_URL ${URL})
        elseif (DOWNLOAD_WITH_GITLAB)
            set(TMP_URL ${URL})
            string(REGEX REPLACE ".+/(.+)/.+$" "\\1" ORG_NAME ${TMP_URL})
            string(REGEX REPLACE ".+/.+/(.+)$" "\\1" REPO_NAME ${TMP_URL})
            if (DEFINED REF)
                set(TMP_URL "${URL}/-/archive/${REF}/${REPO_NAME}-${REF}.tar.gz")
                set(TMP_FILENAME "${ORG_NAME}-${REPO_NAME}-${REF}.tar.gz")
            else()
                string(REGEX REPLACE "^${REPO_NAME}\\-(.+)\\..+" "\\1" TMP_VER ${FILENAME})
                string(REGEX REPLACE "(\\.(zip|gz|tar|tgz|bz2))+\$" "" TMP_VER ${TMP_VER})
                message("TMP_VER: ${TMP_VER}")
                set(TMP_URL "${URL}/-/archive/${TMP_VER}/${FILENAME}")
                set(TMP_FILENAME "${FILENAME}")
            endif()
        endif()
        
        if(EXISTS ${DOWNLOADS}/${TMP_FILENAME})
            message(STATUS "Using pre-downloaded: ${NATIVE_DOWNLOADS}\\${TMP_FILENAME}")
            message(STATUS "If this is not desired, delete the file and ${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}")
        else()
            include(vcpkg_download_distfile)
            set(_VCPKG_INTERNAL_NO_HASH_CHECK "TRUE")
            vcpkg_download_distfile(ARCHIVE
                URLS ${TMP_URL}
                FILENAME ${TMP_FILENAME}
            )
            set(_VCPKG_INTERNAL_NO_HASH_CHECK "FALSE")
        endif()
        file(SHA512 ${DOWNLOADS}/${TMP_FILENAME} SHA512)
    endif()

    file(MAKE_DIRECTORY ports/${PORT})
    # Judge build process
    macro (_get_build_process_cmake SEL_TRIPLET)
        if (${SEL_TRIPLET} STREQUAL cmake)
            set(BUILD_PROCESS_FILE vcpkg_cmake_process.cmake)
        elseif (${SEL_TRIPLET} STREQUAL make)
            set(BUILD_PROCESS_FILE vcpkg_make_process.cmake)
        elseif (${SEL_TRIPLET} STREQUAL msbuild)
            set(BUILD_PROCESS_FILE vcpkg_msbuild_process.cmake)
        elseif (${SEL_TRIPLET} STREQUAL nmake)
            set(BUILD_PROCESS_FILE vcpkg_nmake_process.cmake)
        elseif (${SEL_TRIPLET} STREQUAL qmake)
            set(BUILD_PROCESS_FILE vcpkg_qmake_process.cmake)
        else()
            message(FATAL_ERROR "unsupported build type.")
        endif()
    endmacro()
    if (NOT DEFINED TRIPLET_ALL AND NOT DEFINED TRIPLET_WIN AND NOT DEFINED TRIPLET_LINUX AND NOT DEFINED TRIPLET_OSX)
        set(TRIPLET_ALL cmake)
    endif()
    
    if (DEFINED TRIPLET_ALL)
        set(SELECT_TRIPLETS 1)
        _get_build_process_cmake(TRIPLET_ALL)
        configure_file(${SCRIPTS}/templates/${BUILD_PROCESS_FILE}.in ports/${PORT}/${BUILD_PROCESS_FILE} @ONLY)
        file(READ ports/${PORT}/${BUILD_PROCESS_FILE} BUILD_PROCESS)
        file(REMOVE ports/${PORT}/${BUILD_PROCESS_FILE})
    else()
        if (DEFINED TRIPLET_WIN)
            set(SELECT_TRIPLETS VCPKG_TARGET_IS_WINDOWS)
            _get_build_process_cmake(TRIPLET_WIN)
            configure_file(${SCRIPTS}/templates/${BUILD_PROCESS_FILE}.in ports/${PORT}/${BUILD_PROCESS_FILE} @ONLY)
            file(READ ports/${PORT}/${BUILD_PROCESS_FILE} BUILD_PROCESS_SINGLE)
            file(REMOVE ports/${PORT}/${BUILD_PROCESS_FILE})
            string(APPEND BUILD_PROCESS "\n${BUILD_PROCESS_SINGLE}")
        endif()
        if (DEFINED TRIPLET_LINUX)
            set(SELECT_TRIPLETS VCPKG_TARGET_IS_LINUX)
            _get_build_process_cmake(TRIPLET_LINUX)
            configure_file(${SCRIPTS}/templates/${BUILD_PROCESS_FILE}.in ports/${PORT}/${BUILD_PROCESS_FILE} @ONLY)
            file(READ ports/${PORT}/${BUILD_PROCESS_FILE} BUILD_PROCESS_SINGLE)
            file(REMOVE ports/${PORT}/${BUILD_PROCESS_FILE})
            string(APPEND BUILD_PROCESS "\n${BUILD_PROCESS_SINGLE}")
        endif()
        if (DEFINED TRIPLET_OSX)
            set(SELECT_TRIPLETS VCPKG_TARGET_IS_OSX)
            _get_build_process_cmake(TRIPLET_OSX)
            configure_file(${SCRIPTS}/templates/${BUILD_PROCESS_FILE}.in ports/${PORT}/${BUILD_PROCESS_FILE} @ONLY)
            file(READ ports/${PORT}/${BUILD_PROCESS_FILE} BUILD_PROCESS_SINGLE)
            file(REMOVE ports/${PORT}/${BUILD_PROCESS_FILE})
            string(APPEND BUILD_PROCESS "\n${BUILD_PROCESS_SINGLE}")
        endif()
    endif()
    
    # Judge download type
    set(REF ${FILENAME})
    # Remove file suffix
    string(REPLACE ".tar.gz" "" REF "${REF}")
    string(REPLACE ".zip" "" REF "${REF}")
    string(REPLACE ".bz2" "" REF "${REF}")
    if (DOWNLOAD_WITH_GITHUB)
        string(REGEX REPLACE ".+/(.+)/.+$" "\\1" USER_NAME ${URL})
        string(REGEX REPLACE ".+/.+/(.+)$" "\\1" PROJECT_NAME ${URL})
        configure_file(${SCRIPTS}/templates/vcpkg_github_process.cmake.in ports/${PORT}/vcpkg_github_process.cmake @ONLY)
        file(READ ports/${PORT}/vcpkg_github_process.cmake DOWNLOAD_PROCESS)
        file(REMOVE ports/${PORT}/vcpkg_github_process.cmake)
    elseif (DOWNLOAD_WITH_GITLAB)
        string(REGEX REPLACE ".+/(.+)/.+$" "\\1" USER_NAME ${URL})
        string(REGEX REPLACE ".+/.+/(.+)$" "\\1" PROJECT_NAME ${URL})
        string(REGEX REPLACE "(.+)/.+/.+$" "\\1" URL ${URL})
        string(REGEX REPLACE "^${PROJECT_NAME}-(.+)" "\\1" REF "${REF}")
        configure_file(${SCRIPTS}/templates/vcpkg_gitlab_process.cmake.in ports/${PORT}/vcpkg_gitlab_process.cmake @ONLY)
        file(READ ports/${PORT}/vcpkg_gitlab_process.cmake DOWNLOAD_PROCESS)
        file(REMOVE ports/${PORT}/vcpkg_gitlab_process.cmake)
    elseif (DOWNLOAD_WITH_GIT)
        configure_file(${SCRIPTS}/templates/vcpkg_git_process.cmake.in ports/${PORT}/vcpkg_git_process.cmake @ONLY)
        file(READ ports/${PORT}/vcpkg_git_process.cmake DOWNLOAD_PROCESS)
        file(REMOVE ports/${PORT}/vcpkg_git_process.cmake)
    else()
        #DOWNLOAD_WITH_URL
        configure_file(${SCRIPTS}/templates/vcpkg_url_process.cmake.in ports/${PORT}/vcpkg_url_process.cmake @ONLY)
        file(READ ports/${PORT}/vcpkg_url_process.cmake DOWNLOAD_PROCESS)
        file(REMOVE ports/${PORT}/vcpkg_url_process.cmake)
    endif()
    
    configure_file(${SCRIPTS}/templates/portfile.cmake.in ports/${PORT}/portfile.cmake @ONLY)
    configure_file(${SCRIPTS}/templates/CONTROL.in ports/${PORT}/CONTROL @ONLY)

    message(STATUS "Generated portfile: ${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}\\portfile.cmake")
    message(STATUS "Generated CONTROL: ${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}\\CONTROL")
    message(STATUS "To launch an editor for these new files, run")
    message(STATUS "    .\\vcpkg edit ${PORT}")
endif()
