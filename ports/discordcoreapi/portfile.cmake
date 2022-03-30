vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO RealTimeChris/DiscordCoreAPI
	REF 69b5e58bf2038f5cab77ae42910d5625d91a92e9
	SHA512 8b32c29617a06c2293afa7150ed9038fe07d611c1bfb62d97acef32008c4d488129090668f1c3666ca372daa949aaa9c9b0746a7919c4e88496754d02a8f43c8
	HEAD_REF main
)

vcpkg_configure_cmake(
	SOURCE_PATH "${SOURCE_PATH}"
	DISABLE_PARALLEL_CONFIGURE
	MAYBE_UNUSED_VARIABLES
	"${VCPKG_INSTALLED_DIR}"
	PREFER_NINJA
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/bin" "${CURRENT_PACKAGES_DIR}/bin")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
	INSTALL "${SOURCE_PATH}/License"
	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
	RENAME copyright
)
