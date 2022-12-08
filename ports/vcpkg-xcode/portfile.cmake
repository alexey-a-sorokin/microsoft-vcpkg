if(VCPKG_CROSSCOMPILING)
    message(WARNING "vcpkg-xcode is a host-only port; please mark it as a host port in your dependencies.")
endif()

execute_process(
    COMMAND xcode-select --install
    OUTPUT_VARIABLE OUTPUTS
    ERROR_VARIABLE ERROR_OUTPUT
)

if (NOT "${ERROR_OUTPUT}" MATCHES "command line tools are already installed")
    message(FATAL_ERROR "Please install Xcode command line tool first using the following command first:\nxcode-select --install")
endif()

execute_process(
    COMMAND xcode-select -p
    OUTPUT_VARIABLE OUTPUTS
    ERROR_VARIABLE ERROR_OUTPUT
)
message("OUTPUTS: ${OUTPUTS}")
message("ERROR_OUTPUT: ${ERROR_OUTPUT}")

file(INSTALL
    "${CMAKE_CURRENT_LIST_DIR}/vcpkg_xcode_build.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/vcpkg_xcode_install.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/vcpkg-port-config.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(INSTALL "${VCPKG_ROOT_DIR}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
set(VCPKG_POLICY_CMAKE_HELPER_PORT enabled)
