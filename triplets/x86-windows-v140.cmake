set(VCPKG_TARGET_ARCHITECTURE x86)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_PLATFORM_TOOLSET v140)
if(PORT MATCHES "opencv")
set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

