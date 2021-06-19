vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO mikke89/RmlUi
	REF 4.1
	SHA512 f79bd30104c42469142e4c79a81f120c61f5bd3ae918df9847fa42d05fcda372d3adb5f6884c81c8517a440a81235e70ffcdde8d98751a14d2e4265fc2051a01
	HEAD_REF master
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
	FEATURES 
		lua             BUILD_LUA_BINDINGS
	INVERTED_FEATURES
		freetype        NO_FONT_INTERFACE_DEFAULT
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
	vcpkg_replace_string(${SOURCE_PATH}/Include/RmlUi/Core/Header.h
		"#if !defined RMLUI_STATIC_LIB"
		"#if 0"
	)
	vcpkg_replace_string(${SOURCE_PATH}/Include/RmlUi/Debugger/Header.h
		"#if !defined RMLUI_STATIC_LIB"
		"#if 0"
	)
	if ("lua" IN_LIST FEATURES)
		vcpkg_replace_string(${SOURCE_PATH}/Include/RmlUi/Lua/Header.h
			"#if !defined RMLUI_STATIC_LIB"
			"#if 0"
		)
	endif()
endif()

# Replace built-in thirdparty header
file(COPY
	${CURRENT_INSTALLED_DIR}/include/robin_hood.h
	DESTINATION ${SOURCE_PATH}/Include/RmlUi/Core/Containers
)

vcpkg_cmake_configure(
	SOURCE_PATH ${SOURCE_PATH}
	OPTIONS
		${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(
	CONFIG_PATH  lib/RmlUi/cmake
)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE 
	${CURRENT_PACKAGES_DIR}/debug/include
	${CURRENT_PACKAGES_DIR}/debug/lib/RmlUi
	${CURRENT_PACKAGES_DIR}/lib/RmlUi
)

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
