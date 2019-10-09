include(vcpkg_common_functions)

# LLVM documentation recommends always using static library linkage when
# building with Microsoft toolchain; it's also the default on other platforms
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

set(LLVM_VERSION 9.0.0)

if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    message(FATAL_ERROR "llvm cannot currently be built for UWP")
endif()

vcpkg_download_distfile(ARCHIVE
    URLS "http://releases.llvm.org/${LLVM_VERSION}/llvm-${LLVM_VERSION}.src.tar.xz"
    FILENAME "llvm-${LLVM_VERSION}.src.tar.xz"
    SHA512 1bb3341e1d231559b948f1505b33c2e2e03989f9b8bbfef0e0cdaff5ac43f85574c9ec5ac53399b914f497d6899425d861411024e8d7e1d1a338c1c6951ac658
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES
        install-llvm-modules-to-share.patch
        fix-linux-build.patch
)

vcpkg_download_distfile(CLANG_ARCHIVE
    URLS "http://releases.llvm.org/${LLVM_VERSION}/cfe-${LLVM_VERSION}.src.tar.xz"
    FILENAME "cfe-${LLVM_VERSION}.src.tar.xz"
    SHA512 83fcca5499102b375e620cdac97d75e6111ebed4ef10240859ddd8a88bc5b022703739d2eae0d8693c91892ad11fc6b531c0dbee62fbce68d3be595b94f0b1fe
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH CLANG_SOURCE_PATH
    ARCHIVE ${CLANG_ARCHIVE}
    PATCHES
        fix-build-error.patch
        install-clang-modules-to-share.patch
)

if(NOT EXISTS ${SOURCE_PATH}/tools/clang)
  file(RENAME ${CLANG_SOURCE_PATH} ${SOURCE_PATH}/tools/clang)
endif()

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${PYTHON3_DIR}")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DLLVM_TARGETS_TO_BUILD=X86
        -DLLVM_INCLUDE_TOOLS=ON
        -DLLVM_INCLUDE_UTILS=OFF
        -DLLVM_INCLUDE_EXAMPLES=OFF
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_ABI_BREAKING_CHECKS=FORCE_OFF
        -DLLVM_TOOLS_INSTALL_DIR=tools/llvm
        -DLLVM_PARALLEL_LINK_JOBS=1
)

vcpkg_install_cmake()

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    file(GLOB EXE ${CURRENT_PACKAGES_DIR}/bin/*)
    file(COPY ${EXE} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/llvm)
    file(REMOVE ${EXE})
endif()

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(GLOB DEBUG_EXE ${CURRENT_PACKAGES_DIR}/debug/bin/*)
    file(COPY ${DEBUG_EXE} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/tools/llvm)
    file(REMOVE ${DEBUG_EXE})
endif()

vcpkg_fixup_cmake_targets(CONFIG_PATH share/clang TARGET_PATH share/clang)
vcpkg_fixup_cmake_targets(CONFIG_PATH share/llvm)
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/llvm)

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    file(READ ${CURRENT_PACKAGES_DIR}/share/clang/ClangTargets-release.cmake RELEASE_MODULE)
    string(REPLACE "\${_IMPORT_PREFIX}/bin" "\${_IMPORT_PREFIX}/tools/llvm" RELEASE_MODULE "${RELEASE_MODULE}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/clang/ClangTargets-release.cmake "${RELEASE_MODULE}")

    file(READ ${CURRENT_PACKAGES_DIR}/share/llvm/LLVMExports-release.cmake RELEASE_MODULE)
    string(REPLACE "\${_IMPORT_PREFIX}/bin" "\${_IMPORT_PREFIX}/tools/llvm" RELEASE_MODULE "${RELEASE_MODULE}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/llvm/LLVMExports-release.cmake "${RELEASE_MODULE}")
endif()

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(READ ${CURRENT_PACKAGES_DIR}/share/clang/ClangTargets-debug.cmake DEBUG_MODULE)
    string(REPLACE "\${_IMPORT_PREFIX}/debug/bin" "\${_IMPORT_PREFIX}/tools/llvm" DEBUG_MODULE "${DEBUG_MODULE}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/clang/ClangTargets-debug.cmake "${DEBUG_MODULE}")

    file(READ ${CURRENT_PACKAGES_DIR}/share/llvm/LLVMExports-debug.cmake DEBUG_MODULE)
    string(REPLACE "\${_IMPORT_PREFIX}/debug/bin" "\${_IMPORT_PREFIX}/tools/llvm" DEBUG_MODULE "${DEBUG_MODULE}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/llvm/LLVMExports-debug.cmake "${DEBUG_MODULE}")
endif()

if (EXISTS ${CURRENT_PACKAGES_DIR}/share/llvm/LLVMConfig.cmake)
    file(READ ${CURRENT_PACKAGES_DIR}/share/llvm/LLVMConfig.cmake LLVM_TOOLS_MODULE)
    string(REPLACE "\${LLVM_INSTALL_PREFIX}/bin" "\${LLVM_INSTALL_PREFIX}/tools/llvm" LLVM_TOOLS_MODULE "${LLVM_TOOLS_MODULE}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/llvm/LLVMConfig.cmake "${LLVM_TOOLS_MODULE}")
endif()

file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include
    ${CURRENT_PACKAGES_DIR}/debug/tools
    ${CURRENT_PACKAGES_DIR}/debug/share
    ${CURRENT_PACKAGES_DIR}/debug/bin
    ${CURRENT_PACKAGES_DIR}/debug/msbuild-bin
    ${CURRENT_PACKAGES_DIR}/bin
    ${CURRENT_PACKAGES_DIR}/msbuild-bin
    ${CURRENT_PACKAGES_DIR}/tools/msbuild-bin
    ${CURRENT_PACKAGES_DIR}/include/llvm/BinaryFormat/WasmRelocs
)

# Remove two empty include subdirectorys if they are indeed empty
file(GLOB MCANALYSISFILES ${CURRENT_PACKAGES_DIR}/include/llvm/MC/MCAnalysis/*)
if(NOT MCANALYSISFILES)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/llvm/MC/MCAnalysis)
endif()

file(GLOB MACHOFILES ${CURRENT_PACKAGES_DIR}/include/llvm/TextAPI/MachO/*)
if(NOT MACHOFILES)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/llvm/TextAPI/MachO)
endif()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.TXT DESTINATION ${CURRENT_PACKAGES_DIR}/share/llvm RENAME copyright)
