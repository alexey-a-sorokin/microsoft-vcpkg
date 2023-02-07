# Due to the complexity involved, this package doesn't install MKL. It instead verifies that MKL is installed.
# Other packages can depend on this package to declare a dependency on MKL.
# If this package is installed, we assume that MKL is properly installed.

set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

set(MKL_REQUIRED_VERSION "20200000")

# https://registrationcenter-download.intel.com/akdlm/IRC_NAS/19150/w_onemkl_p_2023.0.0.25930_offline.exe # windows
# https://registrationcenter-download.intel.com/akdlm/IRC_NAS/19116/m_onemkl_p_2023.0.0.25376_offline.dmg # macos
# https://registrationcenter-download.intel.com/akdlm/irc_nas/19138/l_onemkl_p_2023.0.0.25398_offline.sh # linux

if(VCPKG_TARGET_IS_WINDOWS)
  set(filename w_onemkl_p_2023.0.0.25930_offline.exe)
  set(magic_number 19150)
  set(sha a3eb6b75241a2eccb73ed73035ff111172c55d3fa51f545c7542277a155df84ff72fc826621711153e683f84058e64cb549c030968f9f964531db76ca8a3ed46)
elseif(VCPKG_TARGET_IS_OSX)
  set(filename m_onemkl_p_2023.0.0.25376_offline.dmg)
  set(magic_number 19116)
  set(sha 7b9b8c004054603e6830fb9b9c049d5a4cfc0990c224cb182ac5262ab9f1863775a67491413040e3349c590e2cca58edcfc704db9f3b9f9faa8b5b09022cd2af)
  # This is a disk image: If somebody knows how to extract it please do so. 
elseif(VCPKG_TARGET_IS_LINUX)
  set(filename l_onemkl_p_2023.0.0.25398_offline.sh)
  set(magic_number 19138)
  set(sha b5f2f464675f0fd969dde2faf2e622b834eb1cc406c4a867148116f6c24ba5c709d98b678840f4a89a1778e12cde0ff70ce2ef59faeef3d3f3aa1d0329c71af1)
else()
  set(ProgramFilesx86 "ProgramFiles(x86)")
  set(INTEL_ROOT $ENV{${ProgramFilesx86}}/IntelSWTools/compilers_and_libraries/windows)
  set(ONEMKL_ROOT $ENV{${ProgramFilesx86}}/Intel/oneAPI/mkl/latest)

  find_path(MKL_ROOT include/mkl.h
      PATHS
      $ENV{MKLROOT}
      ${INTEL_ROOT}/mkl
      $ENV{ONEAPI_ROOT}/mkl/latest
      ${ONEMKL_ROOT}
      DOC
      "Folder contains MKL")

  if (MKL_ROOT STREQUAL "MKL_ROOT-NOTFOUND")
      message(FATAL_ERROR "Could not find MKL. Before continuing, please download and install MKL  (${MKL_REQUIRED_VERSION} or higher) from:"
                          "\n    https://registrationcenter.intel.com/en/products/download/3178/\n"
                          "\nAlso ensure vcpkg has been rebuilt with the latest version (v0.0.104 or later)")
  endif()

  # file(STRINGS ${MKL_ROOT}/include/mkl_version.h MKL_VERSION_DEFINITION REGEX "__INTEL_MKL((_MINOR)|(_UPDATE))?__")
  # string(REGEX MATCHALL "([0-9]+)" MKL_VERSION ${MKL_VERSION_DEFINITION})
  # list(GET MKL_VERSION 0 MKL_VERSION_MAJOR)
  # list(GET MKL_VERSION 1 MKL_VERSION_MINOR)
  # list(GET MKL_VERSION 2 MKL_VERSION_UPDATE)

  file(STRINGS ${MKL_ROOT}/include/mkl_version.h MKL_VERSION_DEFINITION REGEX "INTEL_MKL_VERSION")
  string(REGEX MATCH "([0-9]+)" MKL_VERSION ${MKL_VERSION_DEFINITION})

  if (MKL_VERSION LESS MKL_REQUIRED_VERSION)
      message(FATAL_ERROR "MKL ${MKL_VERSION} is found but ${MKL_REQUIRED_VERSION} is required. Please download and install a more recent version of MKL from:"
                          "\n    https://registrationcenter.intel.com/en/products/download/3178/\n")
  endif()

endif()

if(sha)
  vcpkg_download_distfile(archive_path
      URLS "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/${magic_number}/${filename}"
      FILENAME "${filename}"
      SHA512 ${sha}
  )

  file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/manual-tools/${PORT}")

  # Note: intel_thread and lp64 are the defaults.
  set(interface "lp64") # or ilp64; ilp == 64 bit int api
  if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
      set(threading "intel_thread") #sequential or intel_thread or tbb_thread or pgi_thread
  else()
      set(threading "sequential")
  endif()
  if(threading STREQUAL "intel_thread")
      set(short_thread "iomp")
  else()
      string(SUBSTRING "${threading}" "0" "3" short_thread)
  endif()

  if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_find_acquire_program(7Z)
    vcpkg_execute_in_download_mode(
                            COMMAND "${7Z}" x "${archive_path}" "-o${CURRENT_PACKAGES_DIR}/intel-extract" "-y" "-bso0" "-bsp0"
                            WORKING_DIRECTORY "${CURRENT_PACKAGES_DIR}/manual-tools/${PORT}"
                        )
                        

    set(packages 
        "intel.oneapi.win.mkl.devel,v=2023.0.0-25930/oneapi-mkl-devel-for-installer_p_2023.0.0.25930.msi" # has the required libs. 
        "intel.oneapi.win.mkl.runtime,v=2023.0.0-25930/oneapi-mkl-for-installer_p_2023.0.0.25930.msi" # has the required DLLs
        #"intel.oneapi.win.compilers-common-runtime,v=2023.0.0-25922" # SVML
        "intel.oneapi.win.openmp,v=2023.0.0-25922/oneapi-comp-openmp-for-installer_p_2023.0.0.25922.msi" # OpenMP
        #"intel.oneapi.win.tbb.runtime,v=2021.8.0-25874" #TBB
        )

    set(output_path "${CURRENT_PACKAGES_DIR}/manual-tools/${PORT}") # vcpkg.cmake adds everything in /tools to CMAKE_PROGRAM_PATH. That is not desired 
    file(MAKE_DIRECTORY "${output_path}")
    foreach(pack IN LISTS packages)
        set(archive_path "${CURRENT_PACKAGES_DIR}/intel-extract/packages/${pack}")
        cmake_path(GET pack STEM LAST_ONLY packstem)
        cmake_path(NATIVE_PATH archive_path archive_path_native)
            vcpkg_execute_in_download_mode(
                            COMMAND "${CURRENT_HOST_INSTALLED_DIR}/tools/vcpkg-tool-lessmsi/lessmsi.exe" x "${archive_path_native}" # Using output_path here does not work in bash
                            WORKING_DIRECTORY "${output_path}" 
                            OUTPUT_FILE "${CURRENT_BUILDTREES_DIR}/lessmsi-${TARGET_TRIPLET}-out.log"
                            ERROR_FILE "${CURRENT_BUILDTREES_DIR}/lessmsi-${TARGET_TRIPLET}-err.log"
                            RESULT_VARIABLE error_code
                        )
        file(COPY "${output_path}/${packstem}/SourceDir/" DESTINATION "${output_path}")
        file(REMOVE_RECURSE "${output_path}/${packstem}")
    endforeach()

    set(basepath "${output_path}/Intel/Compiler/12.0/mkl/2023.0.0/")
    set(basepath2 "${output_path}/Intel/Compiler/12.0/compiler/2023.0.0/")
    file(REMOVE_RECURSE "${output_path}/Intel/shared files"
                        "${output_path}/Intel/Compiler/12.0/conda_channel"
                        "${basepath}tools"
                        "${basepath}interfaces"
                        "${basepath}examples"
                        "${basepath}bin"
                        "${basepath}benchmarks"
                        )

    file(COPY "${basepath}/include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include")
    # see https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-link-line-advisor.html for linking
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
      set(files "mkl_core_dll.lib" "mkl_${threading}_dll.lib" "mkl_intel_${interface}_dll.lib" "mkl_blas95_${interface}.lib" "mkl_lapack95_${interface}.lib") # "mkl_rt.lib" single dynamic lib with dynamic dispatch
      file(COPY "${basepath}redist/intel64/" DESTINATION "${CURRENT_PACKAGES_DIR}/bin") # Could probably be reduced instead of copying all
      if(NOT VCPKG_BUILD_TYPE)
        file(COPY "${basepath}redist/intel64/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
      endif()
    else()
      set(files "mkl_core.lib" "mkl_${threading}.lib" "mkl_intel_${interface}.lib" "mkl_blas95_${interface}.lib" "mkl_lapack95_${interface}.lib")
    endif()
    foreach(file ${files})
      file(COPY "${basepath}lib/intel64/${file}" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/intel64") # instead of manual-link keep normal structure
      if(NOT VCPKG_BUILD_TYPE)
        file(COPY "${basepath}lib/intel64/${file}" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/intel64")
      endif()
    endforeach()

    configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/mkl.pc" @ONLY)
    if(NOT VCPKG_BUILD_TYPE)
      configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/mkl.pc" @ONLY)
    endif()

    if(threading STREQUAL "intel_thread")
      file(COPY "${basepath2}windows/redist/intel64_win/compiler/" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
      file(COPY "${basepath2}windows/compiler/lib/intel64_win/" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/intel64")
      configure_file("${basepath2}lib/pkgconfig/openmp.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libiomp5.pc" @ONLY)
      vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libiomp5.pc" "/windows/compiler/lib/intel64_win/" "/lib/intel64/")
      if(NOT VCPKG_BUILD_TYPE)
          file(COPY "${basepath2}windows/redist/intel64_win/compiler/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
          file(COPY "${basepath2}windows/compiler/lib/intel64_win/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/intel64")
          configure_file("${basepath2}lib/pkgconfig/openmp.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libiomp5.pc" @ONLY)
          vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libiomp5.pc" "/windows/compiler/lib/intel64_win/" "/lib/intel64/")
      endif()
      configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/mkl.pc" @ONLY)
      vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/mkl.pc" "openmp" "libiomp5")
      if(NOT VCPKG_BUILD_TYPE)
        configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/mkl.pc" @ONLY)
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/mkl.pc" "openmp" "libiomp5")
      endif()
    endif()


    file(COPY "${basepath}lib/cmake/" DESTINATION "${CURRENT_PACKAGES_DIR}/share/")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/mkl/MKLConfig.cmake" "MKL_CMAKE_PATH}/../../../" "MKL_CMAKE_PATH}/../../")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/mkl/MKLConfig.cmake" "redist/\${MKL_ARCH}/" "bin")
    #TODO: Hardcode settings from portfile in config.cmake
    #TODO. Give lapack/blas information about the correct BLA_VENDOR depending on settings. 

    file(INSTALL "${CURRENT_PACKAGES_DIR}/intel-extract/packages/intel.oneapi.win.mkl.product,v=2023.0.0-25930/licenses/license.htm" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
    file(INSTALL "${basepath}licensing" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
  elseif(VCPKG_TARGET_IS_LINUX)
    #./l_onemkl_p_2023.0.0.25398_offline.sh --extract-only -a -s
    # cmake -E tar -xf <payload>
    
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/intel-extract")
    vcpkg_execute_in_download_mode(
                            COMMAND "${archive_path}" "--extract-only" "-a" "-s"
                            WORKING_DIRECTORY "${CURRENT_PACKAGES_DIR}/intel-extract"
                        )
    set(packages 
      "intel.oneapi.lin.mkl.devel,v=2023.0.0-25398" # has the required staic libs. 
      "intel.oneapi.lin.mkl.runtime,v=2023.0.0-25398" # has the required dynamic so.
      "intel.oneapi.lin.openmp,v=2023.0.0-25370" #OpenMP
      )
    set(output_path "${CURRENT_PACKAGES_DIR}/intel-extract")
    file(MAKE_DIRECTORY "${output_path}")
    foreach(pack IN LISTS packages)
        set(archive_path "${CURRENT_PACKAGES_DIR}/intel-extract/packages/${pack}")
            vcpkg_execute_in_download_mode(
                            COMMAND "${CMAKE_COMMAND}" "-E" "tar" "-xf" "${output_path}/l_onemkl_p_2023.0.0.25398_offline/packages/${pack}/cupPayload.cup"
                            WORKING_DIRECTORY "${output_path}" 
            )
    endforeach()

    set(basepath "${output_path}/_installdir/mkl/2023.0.0/")
    set(basepath2 "${output_path}/_installdir/compiler/2023.0.0/")
    file(REMOVE_RECURSE "${basepath}../../conda_channel/"
                        "${basepath}tools"
                        "${basepath}interfaces"
                        "${basepath}examples"
                        "${basepath}bin"
                        "${basepath}benchmarks"
                        "${basepath}env"
                        "${basepath}modulefiles"
                        )

    file(COPY "${basepath}include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include")
    file(COPY "${basepath}lib/intel64/" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/intel64")

    configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/mkl.pc" @ONLY)
    if(NOT VCPKG_BUILD_TYPE)
      configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/mkl.pc" @ONLY)
      vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/mkl.pc" "/lib/intel64" "/../lib/intel64")
    endif()

    if(threading STREQUAL "intel_thread")
      file(COPY "${basepath2}linux/compiler/lib/intel64_lin/" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/intel64")
      configure_file("${basepath2}lib/pkgconfig/openmp.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libiomp5.pc" @ONLY)
      vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libiomp5.pc" "/linux/compiler/lib/intel64_lin/" "/lib/intel64/")
      if(NOT VCPKG_BUILD_TYPE)
          file(COPY "${basepath2}linux/compiler/lib/intel64_lin/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/intel64")
          configure_file("${basepath2}lib/pkgconfig/openmp.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libiomp5.pc" @ONLY)
          vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libiomp5.pc" "/linux/compiler/lib/intel64_lin/" "/lib/intel64/")
      endif()
      configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/mkl.pc" @ONLY)
      vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/mkl.pc" "openmp" "libiomp5")
      if(NOT VCPKG_BUILD_TYPE)
        configure_file("${basepath}lib/pkgconfig/mkl-${VCPKG_LIBRARY_LINKAGE}-${interface}-${short_thread}.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/mkl.pc" @ONLY)
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/mkl.pc" "openmp" "libiomp5")
      endif()
    endif()

    file(COPY "${basepath}lib/cmake/" DESTINATION "${CURRENT_PACKAGES_DIR}/share/")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/mkl/MKLConfig.cmake" "MKL_CMAKE_PATH}/../../../" "MKL_CMAKE_PATH}/../../")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/mkl/MKLConfig.cmake" "redist/\${MKL_ARCH}/" "bin")
    #TODO: Hardcode settings from portfile in config.cmake

    file(INSTALL "${basepath}licensing/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
    file(INSTALL "${basepath}licensing" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
  endif()

  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/intel-extract"
                      "${CURRENT_PACKAGES_DIR}/manual-tools"
                      )
endif()