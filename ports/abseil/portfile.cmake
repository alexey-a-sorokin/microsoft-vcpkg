if (NOT VCPKG_TARGET_IS_WINDOWS)
vcpkg_check_linkage(ONLY_STATIC_LIBRARY) endif()

<<<<<<< HEAD
    == == ==
    = set(ABSEIL_PATCHES)

>>>>>>> a08f2dc10... [abseil] Update to 20200923.2 version
        if ("cxx17" IN_LIST FEATURES)
#in C++ 17 mode, use std::any, std::optional, std::string_view, std::variant
#instead of the library replacement types
            list(APPEND ABSEIL_PATCHES fix - use - cxx17 - stdlib -
                 types.patch) else()
#force use of library replacement types, otherwise the automatic

#detection can cause ABI issues depending on which compiler options
#are enabled for consuming user code
                list(APPEND ABSEIL_PATCHES fix - lnk2019 - error.patch) endif()

                    vcpkg_from_github(
                        OUT_SOURCE_PATH SOURCE_PATH REPO abseil / abseil -
                        cpp REF 0f3bb466b868b523cf1dc9b2aaaed65c77b28862 #commit 2020 -
                        10 -
                        21 SHA512 17e766a2f7a655a3877eb3accc5745a910b69a5e2426b7ce7f6d31095523dd32d48a709c5f8380488b4cb93ce9faadedc08f0481dbdbd00cf68831541d724b4d HEAD_REF
                            master PATCHES ${ABSEIL_PATCHES})

                        set(CMAKE_CXX_STANDARD 11) if (
                            "cxx17" IN_LIST
                                FEATURES) set(CMAKE_CXX_STANDARD 17) endif()

                            vcpkg_configure_cmake(
                                SOURCE_PATH ${
                                    SOURCE_PATH} PREFER_NINJA OPTIONS -
                                    DCMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD})

                                vcpkg_install_cmake() vcpkg_fixup_cmake_targets(
                                    CONFIG_PATH lib / cmake /
                                    absl TARGET_PATH share / absl)

                                    vcpkg_copy_pdbs() file(
                                        REMOVE_RECURSE ${CURRENT_PACKAGES_DIR} /
                                        debug / share ${CURRENT_PACKAGES_DIR} /
                                        debug /
                                        include ${CURRENT_PACKAGES_DIR} /
                                        include / absl /
                                        copts ${CURRENT_PACKAGES_DIR} /
                                        include / absl / strings /
                                        testdata ${CURRENT_PACKAGES_DIR} /
                                        include / absl / time / internal /
                                        cctz / testdata)

                                        if (VCPKG_LIBRARY_LINKAGE STREQUAL
                                                dynamic)
                                            vcpkg_replace_string(
                                                ${CURRENT_PACKAGES_DIR} /
                                                include / absl / base /
                                                config.h
                                                "#elif "
                                                "defined(ABSL_CONSUME_DLL)"
                                                "#elif 1")
                                                vcpkg_replace_string(
                                                    ${CURRENT_PACKAGES_DIR} /
                                                    include / absl / base /
                                                    internal /
                                                    thread_identity.h
                                                    "&& "
                                                    "!defined(ABSL_CONSUME_DLL)"
                                                    "&& 0")
                                                    vcpkg_replace_string(
                                                        ${CURRENT_PACKAGES_DIR} /
                                                        include / absl /
                                                        container / internal /
                                                        hashtablez_sampler.h
                                                        "!defined(ABSL_CONSUME_"
                                                        "DLL)"
                                                        "0") endif()

                                                        file(
                                                            INSTALL ${
                                                                SOURCE_PATH} /
                                                            LICENSE DESTINATION ${
                                                                CURRENT_PACKAGES_DIR} /
                                                            share /
                                                            ${PORT} RENAME
                                                                copyright)
