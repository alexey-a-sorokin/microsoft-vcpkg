
include("${CMAKE_CURRENT_LIST_DIR}/download_llvm.cmake")

set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)
set(VCPKG_ENV_PASSTHROUGH_UNTRACKED "LLVMInstallDir;LLVMToolsVersion") 
set(VCPKG_QT_TARGET_MKSPEC win32-clang-msvc)
set(VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK enabled)
set(VCPKG_POLICY_SKIP_DUMPBIN_CHECKS enabled)
set(VCPKG_LOAD_VCVARS_ENV ON)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/x64-windows-llvm.toolchain.cmake")
if(DEFINED VCPKG_PLATFORM_TOOLSET)
    set(VCPKG_PLATFORM_TOOLSET ClangCL)
endif()
include("${CMAKE_CURRENT_LIST_DIR}/port_flags.cmake")
