_find_package(${ARGS})

if(TARGET OpenEXR::IlmImf AND NOT OPENEXR_LIBRARIES AND NOT OPENEXR_FOUND)
  set(OPENEXR_FOUND TRUE)
  set(OPENEXR_VERSION "2.5.0")
  get_target_property(OPENEXR_INCLUDE_PATHS OpenEXR::IlmImf INTERFACE_INCLUDE_DIRECTORIES)
  get_target_property(OPENEXR_INCLUDE_DIRS OpenEXR::IlmImf INTERFACE_INCLUDE_DIRECTORIES)
  get_target_property(OPENEXR_INCLUDE_DIR OpenEXR::IlmImf INTERFACE_INCLUDE_DIRECTORIES)
  get_target_property(OPENEXR_ILMIMF_LIBRARY OpenEXR::IlmImf INTERFACE_LINK_LIBRARIES)
  get_target_property(OPENEXR_ILMIMFUTIL_LIBRARY OpenEXR::IlmImfUtil INTERFACE_LINK_LIBRARIES)
  set(OPENEXR_LIBRARIES ${OPENEXR_ILMIMFUTIL_LIBRARY} ${OPENEXR_ILMIMF_LIBRARY})
endif()
