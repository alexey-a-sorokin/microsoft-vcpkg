set(VERSION_MAJOR_MINOR 5.12)

set(plat_feat "")
if(VCPKG_TARGET_IS_LINUX)
    set(plat_feat "tools" VTK_USE_X) # required to build the client
endif()
if(VCPKG_TARGET_IS_LINUX)
    set(plat_feat "tools" VTK_USE_COCOA) # required to build the client
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS FEATURES
    "cuda"         PARAVIEW_USE_CUDA            #untested; probably only affects internal VTK build so it does nothing here 
    "all_modules"  PARAVIEW_BUILD_ALL_MODULES   #untested
    "mpi"          PARAVIEW_USE_MPI             #untested
    "vtkm"         PARAVIEW_USE_VTKM
    "python"       PARAVIEW_USE_PYTHON
    "tools"        PARAVIEW_BUILD_TOOLS
    ${plat_feat}
)

vcpkg_download_distfile(
    external_vtk_patch
    URLS https://gitlab.kitware.com/paraview/paraview/-/merge_requests/6375.diff?full_index=1
    FILENAME paraview_external_vtk_pr.diff
    SHA512 c7760599239334817e9cad33ab7019c2dd0ce6740891e10ec15e1d63605ad73095fd7d48aed5ca8d002d25db356a7a5cf2a37188f0b43a7a9fa4c339e8f42adb
)

set(ext_vtk_patch_copy "${CURRENT_BUILDTREES_DIR}/paraview_external_vtk_pr.diff")
file(COPY "${external_vtk_patch}" DESTINATION "${CURRENT_BUILDTREES_DIR}" )

# Remove stuff which cannot be patched since it does not exist
vcpkg_replace_string("${ext_vtk_patch_copy}"
[[
diff --git a/.gitlab/ci/sccache.sh b/.gitlab/ci/sccache.sh
index f1897d6f719c3b61b6d4fa317966c007dab2fc23..e88d7c89198696832e5645bfb0e758fd5d92e6af 100755
--- a/.gitlab/ci/sccache.sh
+++ b/.gitlab/ci/sccache.sh
@@ -37,6 +37,6 @@ $shatool --check sccache.sha256sum
 mv "$filename" sccache
 chmod +x sccache
 
-mkdir shortcuts
+mkdir -p shortcuts
 cp ./sccache shortcuts/gcc
 cp ./sccache shortcuts/g++
]]
""
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Kitware/ParaView
    REF b701926ba2bd753eff36aec56e36ad4d5ac3168b # v5.12.0
    SHA512  9fbebfa11b60c81deec0df7508a0433a1bced620367477e15314e232d50ba6a6196074d3d701434652cb9a2e0c946159f44e8e16682aa6326a89ebd6caa1f5d9
    HEAD_REF master
    PATCHES
        ${ext_vtk_patch_copy}
        add-tools-option.patch
        fix-build.patch
        fix-configure.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND VisItPatches removedoublesymbols.patch)
endif()

#The following two dependencies should probably be their own port 
#but require additional patching in paraview to make it work. 

#Get VisItBridge Plugin
vcpkg_from_gitlab(
    OUT_SOURCE_PATH VISITIT_SOURCE_PATH
    GITLAB_URL https://gitlab.kitware.com/
    REPO paraview/visitbridge
    REF 92ad478e3d6b18b111ef45ab76d6dad5d3530381
    SHA512 c4893929b99419a365e90450f9c6d8a72f30f88aadbfe5c7d23ec4a46e9cf301e0b9c31cd602d1ab717ffb6744ae45abe41cb0e9c1f02b83e4468c702e8d023d
    PATCHES 
        ${VisItPatches}
)
#VTK_MODULE_USE_EXTERNAL_ParaView_protobuf
#NVPipe?
#Get QtTesting Plugin
vcpkg_from_gitlab(
    OUT_SOURCE_PATH QTTESTING_SOURCE_PATH
    GITLAB_URL https://gitlab.kitware.com/
    REPO paraview/qttesting
    REF 9d4346485cfce79ad448f7e5656b2525b255b2ca # https://gitlab.kitware.com/paraview/qttesting/-/merge_requests/53 for Qt6
    SHA512  7561cd66e1a12053b7a81ab7a80ad2163922995317a503761521151668a905602fb1bb23c963e18d2739d17aa4187ccf1b4bd1010b0494aab6d4fc004e0e9760
)

vcpkg_from_gitlab(
    OUT_SOURCE_PATH ICET_SOURCE_PATH
    GITLAB_URL https://gitlab.kitware.com/
    REPO paraview/IceT
    REF 32816fe5592de3be664da6f8466a546f221d8532
    SHA512  33d5e8f2ecdc20d305d04c23fc3a3121d3c5305ddff7f5b71cee1a2c2183c4b36c9d0bd91e9dba5f2369e237782d7dbcf635d2e1814ccde88570647c890edc9d
)

file(COPY "${VISITIT_SOURCE_PATH}/" DESTINATION "${SOURCE_PATH}/Utilities/VisItBridge")
file(COPY "${QTTESTING_SOURCE_PATH}/" DESTINATION "${SOURCE_PATH}/ThirdParty/QtTesting/vtkqttesting")
file(COPY "${ICET_SOURCE_PATH}/" DESTINATION "${SOURCE_PATH}/ThirdParty/IceT/vtkicet")

if("python" IN_LIST FEATURES)
    set(python_ver "")
    if(NOT VCPKG_TARGET_IS_WINDOWS)
        file(GLOB _py3_include_path "${CURRENT_HOST_INSTALLED_DIR}/include/python3*")
        string(REGEX MATCH "python3\\.([0-9]+)" _python_version_tmp ${_py3_include_path})
        set(PYTHON_VERSION_MINOR "${CMAKE_MATCH_1}")
        set(python_ver "3.${PYTHON_VERSION_MINOR}")
    endif()
    list(APPEND ADDITIONAL_OPTIONS
        -DPython3_FIND_REGISTRY=NEVER
        "-DPython3_EXECUTABLE:PATH=${CURRENT_HOST_INSTALLED_DIR}/tools/python3/python${python_ver}${VCPKG_EXECUTABLE_SUFFIX}"
        -DPARAVIEW_PYTHON_SITE_PACKAGES_SUFFIX=${PYTHON3_SITE}
        )
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" PARAVIEW_BUILD_SHARED_LIBS)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
     OPTIONS
        #--trace-expand
        ${FEATURE_OPTIONS}
        -DPARAVIEW_USE_FORTRAN=OFF
        -DPARAVIEW_BUILD_SHARED_LIBS=${PARAVIEW_BUILD_SHARED_LIBS}
        -DPARAVIEW_PLUGIN_DISABLE_XML_DOCUMENTATION:BOOL=ON
        -DPARAVIEW_BUILD_WITH_EXTERNAL:BOOL=ON
        -DPARAVIEW_USE_EXTERNAL_VTK:BOOL=ON
        -DPARAVIEW_ENABLE_VISITBRIDGE:BOOL=ON
        -DVTK_MODULE_ENABLE_ParaView_qttesting=YES
        -DPARAVIEW_ENABLE_EMBEDDED_DOCUMENTATION:BOOL=OFF
        -DPARAVIEW_USE_QTHELP:BOOL=OFF
        # A little bit of help in finding the boost headers
        "-DBoost_INCLUDE_DIR:PATH=${CURRENT_INSTALLED_DIR}/include"

        # Workarounds for CMake issues
        -DHAVE_SYS_TYPES_H=0    ## For some strange reason the test first succeeds and then fails the second time around
        -DWORDS_BIGENDIAN=0     ## Tests fails in VisItCommon.cmake for some unknown reason this is just a workaround since most systems are little endian. 
        ${ADDITIONAL_OPTIONS}

        #-DPARAVIEW_ENABLE_FFMPEG:BOOL=OFF
)
if(CMAKE_HOST_UNIX)
    # ParaView runs Qt tools so LD_LIBRARY_PATH must be set correctly for them to find *.so files
    set(BACKUP_LD_LIBRARY_PATH $ENV{LD_LIBRARY_PATH})
    set(ENV{LD_LIBRARY_PATH} "${BACKUP_LD_LIBRARY_PATH}:${CURRENT_INSTALLED_DIR}/lib")
endif()

vcpkg_cmake_install(ADD_BIN_TO_PATH) # Bin to path required since paraview will use some self build tools

if(CMAKE_HOST_UNIX)
    set(ENV{LD_LIBRARY_PATH} "${BACKUP_LD_LIBRARY_PATH}")
endif()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/paraview-${VERSION_MAJOR_MINOR})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# see https://gitlab.kitware.com/paraview/paraview/-/issues/21328
file(REMOVE "${CURRENT_PACKAGES_DIR}/include/paraview-${VERSION_MAJOR_MINOR}/vtkCPConfig.h")

set(TOOLVER pv${VERSION_MAJOR_MINOR})
set(TOOLS   paraview
            pvbatch
            pvdataserver
            pvpython
            pvrenderserver
            pvserver
            smTestDriver
            vtkProcessXML
            vtkWrapClientServer)

foreach(tool ${TOOLS})
    # Remove debug tools
    set(filename ${CURRENT_PACKAGES_DIR}/debug/bin/${tool}${VCPKG_TARGET_EXECUTABLE_SUFFIX})
    if(EXISTS ${filename})
        file(REMOVE "${filename}")
    endif()
    set(filename ${CURRENT_PACKAGES_DIR}/debug/bin/${tool}-${TOOLVER}${VCPKG_TARGET_EXECUTABLE_SUFFIX})
    if(EXISTS ${filename})
        file(REMOVE "${filename}")
    endif()
    set(filename ${CURRENT_PACKAGES_DIR}/debug/bin/${tool}-${TOOLVER}d${VCPKG_TARGET_EXECUTABLE_SUFFIX})
    if(EXISTS ${filename})
        file(REMOVE "${filename}")
    endif()
    
    # Move release tools
    set(filename ${CURRENT_PACKAGES_DIR}/bin/${tool}${VCPKG_TARGET_EXECUTABLE_SUFFIX})
    if(EXISTS ${filename})
        file(INSTALL "${filename}" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
        file(REMOVE "${filename}")
    endif()
    set(filename ${CURRENT_PACKAGES_DIR}/bin/${tool}-${TOOLVER}${VCPKG_TARGET_EXECUTABLE_SUFFIX})
    if(EXISTS ${filename})
        file(INSTALL "${filename}" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
        file(REMOVE "${filename}")
    endif()
endforeach()
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})

# Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/Copyright.txt")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    macro(move_bin_to_lib name)
        if(EXISTS ${CURRENT_PACKAGES_DIR}/bin/${name})
            file(RENAME "${CURRENT_PACKAGES_DIR}/bin/${name}" "${CURRENT_PACKAGES_DIR}/lib/${name}")
        endif()
        if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/bin/${name})
            file(RENAME "${CURRENT_PACKAGES_DIR}/debug/bin/${name}" "${CURRENT_PACKAGES_DIR}/debug/lib/${name}")
        endif()
    endmacro()
    
    set(to_move Lib paraview-${VERSION_MAJOR_MINOR} paraview-config)
    foreach(name ${to_move})
        move_bin_to_lib(${name})
    endforeach()

    file(GLOB_RECURSE cmake_files ${CURRENT_PACKAGES_DIR}/share/${PORT}/*.cmake)
    foreach(cmake_file ${cmake_files})
        file(READ "${cmake_file}" _contents)
        STRING(REPLACE "bin/" "lib/" _contents "${_contents}")
        file(WRITE "${cmake_file}" "${_contents}")
    endforeach()

    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(GLOB cmake_files "${CURRENT_PACKAGES_DIR}/share/${PORT}/*.cmake")
foreach(file IN LISTS cmake_files)
    vcpkg_replace_string("${file}" "pv${VERSION_MAJOR_MINOR}d.exe" "pv${VERSION_MAJOR_MINOR}.exe")
endforeach() 
 
# The plugins also work without these files
file(REMOVE "${CURRENT_PACKAGES_DIR}/Applications/paraview.app/Contents/Resources/paraview.conf")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/Applications/paraview.app/Contents/Resources/paraview.conf")
