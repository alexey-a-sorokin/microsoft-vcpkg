
if(NOT VCPKG_CRT_LINKAGE STREQUAL "dynamic")
  message(FATAL_ERROR "PDCurses only supports dynamic CRT linkage")
endif()

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET})
find_program(NMAKE nmake)

vcpkg_from_github(
    OUT_SOURCE_PATH <SOURCE_PATH>
    REPO <Bill-Gray/PDCurses>
    HEAD_REF <master>
)

if(EXISTS ${CURRENT_BUILDTREES_DIR}/src)
    file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/src)
endif()

vcpkg_extract_source_archive(${ARCHIVE} ${SOURCE_PATH})

file(READ ${SOURCE_PATH}/win32/vcwin32.mak PDC_MAK_ORIG)
string(REPLACE " -pdb:none" "" PDC_MAK_ORIG ${PDC_MAK_ORIG})

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    string(REPLACE "/MACHINE:IX86 " "/MACHINE:X64 " PDC_MAK_X64 ${PDC_MAK_ORIG})
    file(WRITE ${SOURCE_PATH}/win32/vcpkg_x64.mak ${PDC_MAK_X64})
    set(PDC_NMAKE_CMD ${NMAKE} /A -f vcpkg_x64.mak WIDE=Y UTF8=Y)
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    string(REPLACE "/MACHINE:IX86 " "/MACHINE:X86 " PDC_MAK_X86 ${PDC_MAK_ORIG})
    file(WRITE ${SOURCE_PATH}/win32/vcpkg_x86.mak ${PDC_MAK_X86})
    set(PDC_NMAKE_CMD ${NMAKE} /A -f vcpkg_x86.mak WIDE=Y UTF8=Y)
else()
    message(FATAL_ERROR "Unsupported target architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

set(PDC_NMAKE_CWD ${SOURCE_PATH}/win32)
set(PDC_PDCLIB ${SOURCE_PATH}/win32/pdcurses)

if (VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(PDC_NMAKE_CMD ${PDC_NMAKE_CMD} DLL=Y)
endif()

message(STATUS "Build ${TARGET_TRIPLET}-rel")
vcpkg_execute_required_process(
    COMMAND ${PDC_NMAKE_CMD}
    WORKING_DIRECTORY ${PDC_NMAKE_CWD}
    LOGNAME build-${TARGET_TRIPLET}-rel
)
message(STATUS "Build ${TARGET_TRIPLET}-rel done")

file (
    COPY ${PDC_PDCLIB}.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib
)
if (VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    file (
        COPY ${PDC_PDCLIB}.dll
        DESTINATION ${CURRENT_PACKAGES_DIR}/bin
    )
endif()

message(STATUS "Build ${TARGET_TRIPLET}-dbg")
vcpkg_execute_required_process(
    COMMAND ${PDC_NMAKE_CMD} DEBUG=Y
    WORKING_DIRECTORY ${PDC_NMAKE_CWD}
    LOGNAME build-${TARGET_TRIPLET}-dbg
)
message(STATUS "Build ${TARGET_TRIPLET}-dbg done")

file (
    COPY ${PDC_PDCLIB}.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
)
if (VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    file (
        COPY ${PDC_PDCLIB}.dll
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
    )
endif()

file(
    COPY ${SOURCE_PATH}/curses.h ${SOURCE_PATH}/panel.h ${SOURCE_PATH}/term.h
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
)
file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/pdcurses RENAME copyright)

vcpkg_copy_pdbs()
