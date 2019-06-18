function(_vcpkg_find_and_load_intel_fortran_compiler VERSION_OUT_VAR)

    set(INTEL_VERSIONS 15 16 17 18 19 20 21 22 23 24 25)

    set(POTENTIAL_PATHS)
    foreach(INTEL_VERSION ${INTEL_VERSIONS})
        if(NOT "$ENV{IFORT_COMPILER${INTEL_VERSION}}" STREQUAL "")
            file(TO_CMAKE_PATH "$ENV{IFORT_COMPILER${INTEL_VERSION}}" "IFORT_COMPILER${INTEL_VERSION}")

            list(APPEND POTENTIAL_PATHS "${IFORT_COMPILER${INTEL_VERSION}}")
        endif()
    endforeach()

    set(CURRENT_VERSION "")
    set(CURRENT_COMPILERVARS_BAT_PATH "NOTFOUND")

    foreach(CURRENT_PATH ${POTENTIAL_PATHS})
        set(COMPILERVARS_BAT_PATH "${CURRENT_PATH}/bin/compilervars.bat")
        if(EXISTS ${COMPILERVARS_BAT_PATH})
            get_filename_component(DIRECTORY_NAME ${CURRENT_PATH} DIRECTORY)
            get_filename_component(DIRECTORY_NAME ${DIRECTORY_NAME} NAME)

            string(REPLACE "_" ";" DIRECTORY_NAME_PARTS ${DIRECTORY_NAME})
            list(GET DIRECTORY_NAME_PARTS -1 VERSION)
            if("${VERSION}" MATCHES "^([0-9]+\.)+[0-9]+$")
                if("${CURRENT_VERSION}" STREQUAL "" OR "${VERSION}" VERSION_GREATER "${CURRENT_VERSION}")
                    set(CURRENT_VERSION ${VERSION})
                    set(CURRENT_COMPILERVARS_BAT_PATH ${COMPILERVARS_BAT_PATH})
                endif()
            endif()
        endif()
    endforeach()

    if(CURRENT_COMPILERVARS_BAT_PATH)
        vcpkg_determine_intel_vs_and_arch(INTEL_VS INTEL_ARCH)

        _vcpkg_load_environment_from_batch(
            BATCH_FILE_PATH ${CURRENT_COMPILERVARS_BAT_PATH}
            ARGUMENTS
                ${INTEL_ARCH}
                ${INTEL_VS}
        )
        set(${VERSION_OUT_VAR} "${CURRENT_VERSION}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Could not find Intel Fortran compiler.")
    endif()
endfunction()

function(_vcpkg_find_and_load_pgi_fortran_compiler VERSION_OUT_VAR)
    vcpkg_get_program_files_platform_bitness(PROGRAM_FILES)

    set(PGI_ROOTS "${PROGRAM_FILES}/PGI" "${PROGRAM_FILES}/PGICE")

    set(CURRENT_VERSION "")
    set(CURRENT_PGI_ENV_BAT_PATH "NOTFOUND")

    foreach(PGI_ROOT ${PGI_ROOTS})
        file(GLOB POTENTIAL_PATHS "${PGI_ROOT}/win64/*") # on windows PGI provides x64 host only
        
        foreach(POTENTIAL_PATH ${POTENTIAL_PATHS})
            if(IS_DIRECTORY ${POTENTIAL_PATH})
                set(PGI_ENV_BAT_PATH "${POTENTIAL_PATH}/pgi_env.bat")
                if(EXISTS ${PGI_ENV_BAT_PATH})
                    get_filename_component(VERSION ${POTENTIAL_PATH} NAME)
                    if("${CURRENT_VERSION}" STREQUAL "" OR "${VERSION}" VERSION_GREATER "${CURRENT_VERSION}")
                        set(CURRENT_VERSION ${VERSION})
                        set(CURRENT_PGI_ENV_BAT_PATH ${PGI_ENV_BAT_PATH})
                    endif()
                endif()
            endif()
        endforeach()
    endforeach()

    if(CURRENT_PGI_ENV_BAT_PATH)
        if(NOT "${VCPKG_TARGET_ARCHITECTURE}" STREQUAL "x64")
            message(FATAL_ERROR "PGI Fortran does not support other target architectures than x64")
        endif()

        # NOTE: We do not need to check for the host architecture
        #       since we would not be able to install PGI if the system would not be x64

        _vcpkg_load_environment_from_batch(
            BATCH_FILE_PATH ${CURRENT_PGI_ENV_BAT_PATH}
        )
        set(${VERSION_OUT_VAR} "${CURRENT_VERSION}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Could not find PGI Fortran compiler.")
    endif()
endfunction()

function(_vcpkg_find_and_load_gnu_fortran_compiler VERSION_OUT_VAR)
  if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(MINGW_VERSION "7.1.0")

    if("${VCPKG_TARGET_ARCHITECTURE}" STREQUAL "x86")
      set(URL "https://kent.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/${MINGW_VERSION}/threads-win32/dwarf/i686-${MINGW_VERSION}-release-win32-dwarf-rt_v5-rev2.7z")
      set(ARCHIVE "i686-${MINGW_VERSION}-release-win32-dwarf-rt_v5-rev2.7z")
      set(HASH "a6ec2b0e2a22f6fed6c4d7ad2420726d78afea64f1d5698363e3f7b910ef94cc10898c88130368cbf4b2146eb05d4ae756f330f2605beeef9583448dbb6fe6d6")
      set(MINGW_DIRECTORY_NAME "mingw32")
    elseif("${VCPKG_TARGET_ARCHITECTURE}" STREQUAL "x64")
      set(URL "https://netix.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/${MINGW_VERSION}/threads-win32/seh/x86_64-${MINGW_VERSION}-release-win32-seh-rt_v5-rev2.7z")
      set(ARCHIVE "x86_64-${MINGW_VERSION}-release-win32-seh-rt_v5-rev2.7z")
      set(HASH "19df45d9f1caf2013bd73110548344f6e6e78ecfe37a086d880116e527d385d8f166e9f9be866033e7037fdee9f662ee227f346103f07e488452c37962f7924a")
      set(MINGW_DIRECTORY_NAME "mingw64")
    else()
      message(FATAL "Mingw download not supported for arch ${VCPKG_TARGET_ARCHITECTURE}.")
    endif()

    set(MINGW_PATH "${DOWNLOADS}/tools/mingw/${MINGW_VERSION}")
    set(MINGW_BIN_PATH "${MINGW_PATH}/${MINGW_DIRECTORY_NAME}/bin")

    # Download and extract MinGW if this has not been done yet
    if(NOT EXISTS "${MINGW_BIN_PATH}/gfortran.exe")
      set(ARCHIVE_PATH "${DOWNLOADS}/${ARCHIVE}")

      file(DOWNLOAD "${URL}" "${ARCHIVE_PATH}"
        EXPECTED_HASH SHA512=${HASH}
        SHOW_PROGRESS
      )

      file(MAKE_DIRECTORY "${MINGW_PATH}")

      execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xzf ${ARCHIVE_PATH}
        WORKING_DIRECTORY ${MINGW_PATH}
      )
      
      if(NOT EXISTS "${MINGW_BIN_PATH}/gfortran.exe")
        message(FATAL_ERROR
          "Error while trying to get MinGW GNU Fortran. Could not find:\n"
          "  ${MINGW_BIN_PATH}/gfortran.exe"
        )
      endif()
    endif()

    set(ENV{PATH} "$ENV{PATH};${MINGW_BIN_PATH}")

    # MinGW does not yet support linking against the UCRT, so all binaries compiled by
    # gfortran will link against an old msvcrt.
    # This will disable the post-installation test for the correct runtime-library
    # for all ports that enable the fortran compiler.
    set(VCPKG_POLICY_ALLOW_OBSOLETE_MSVCRT enabled)
    set(${VERSION_OUT_VAR} "${MINGW_VERSION}" PARENT_SCOPE)
  endif()
endfunction()

function(_vcpkg_find_and_load_flang_fortran_compiler VERSION_OUT_VAR)
    vcpkg_find_acquire_program(
      FLANG
      REQUIRED_LIBRARY_PATH_VAR REQUIRED_LIBRARY_PATH
      REQUIRED_BINARY_PATH_VAR REQUIRED_BINARY_PATH
      VERSION_VAR FLANG_VERSION
    )

    vcpkg_add_to_path(${REQUIRED_BINARY_PATH})
    vcpkg_add_to_lib(${REQUIRED_LIBRARY_PATH})

    set(CMAKE_Fortran_COMPILER ${FLANG} CACHE FILEPATH "The Fortran compiler" FORCE)

    set(${VERSION_OUT_VAR} "${FLANG_VERSION}" PARENT_SCOPE)
endfunction()

## # vcpkg_enable_fortran
##
## Tries to detect a fortran compiler and pulls in the environment to use it.
##
## This functions reads the variable `VCPKG_Fortran_COMPILER` to determine which fortran compiler to use.
## Usually this variable should be set in the triplet by the user.
## If it is not set it attempts to automatically detected the compiler the user has installed.
##
## Supported values for `VCPKG_Fortran_COMPILER` are
##
##  - `Intel` = Intel Compiler (intel.com)
##  - `PGI` = The Portland Group (pgroup.com)
##  - `GNU` = GNU Compiler Collection (gcc.gnu.org)
##  - `Flang` = Flang Fortran Compiler
##
## If the variable is not set an error will be raised.
##
## ## Usage:
## ```cmake
## vcpkg_enable_fortran()
## ```
##
## ## Examples:
##
## * [lapack](https://github.com/Microsoft/vcpkg/blob/master/ports/lapack/portfile.cmake)
function(vcpkg_enable_fortran)
    if(DEFINED VCPKG_Fortran_COMPILER)
        if(VCPKG_Fortran_COMPILER STREQUAL "Intel")
            _vcpkg_find_and_load_intel_fortran_compiler(VCPKG_Fortran_TOOLSET_VERSION)
            set(VCPKG_Fortran_IS_INTEL 1)
        elseif(VCPKG_Fortran_COMPILER STREQUAL "PGI")
            _vcpkg_find_and_load_pgi_fortran_compiler(VCPKG_Fortran_TOOLSET_VERSION)
            set(VCPKG_Fortran_IS_PGI 1)
        elseif(VCPKG_Fortran_COMPILER STREQUAL "GNU")
            _vcpkg_find_and_load_gnu_fortran_compiler(VCPKG_Fortran_TOOLSET_VERSION)
            set(VCPKG_Fortran_IS_GNU 1)
        elseif(VCPKG_Fortran_COMPILER STREQUAL "Flang")
            _vcpkg_find_and_load_flang_fortran_compiler(VCPKG_Fortran_TOOLSET_VERSION)
            set(VCPKG_Fortran_IS_FLANG 1)
        else()
            message(FATAL_ERROR
                "Unknown fortran compiler \"${VCPKG_Fortran_COMPILER}\". Currently only the following are supported:\n"
                "  Intel, PGI, GNU and Flang"
            )
        endif()
    else()
        message(STATUS "No Fortran compiler set in triplet, attempting to automatically set one")
        vcpkg_auto_get_fortran_compiler()
    endif()
    set(VCPKG_Fortran_ENABLED ON PARENT_SCOPE)
    set(VCPKG_Fortran_TOOLSET_VERSION "${VCPKG_Fortran_TOOLSET_VERSION}" PARENT_SCOPE)
endfunction()
