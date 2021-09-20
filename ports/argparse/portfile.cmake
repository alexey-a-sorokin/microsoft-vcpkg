# header-only library

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO p-ranav/argparse
    REF b0cb28ab177cdbd19d439c02cdc217bdfc508ba9 #2021-09-14
    SHA512 247f27aa45994ee4629b947e3fe1b1df8fae4e773992c740a7c3d544e45ce83a68ecdcfdedf38c461ccb81cf93d88dfee21dc4f7d027677a3c7d930170446971
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DARGPARSE_BUILD_TESTS=OFF
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/${PORT})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug ${CURRENT_PACKAGES_DIR}/lib)

# Handle copyright
configure_file(${SOURCE_PATH}/LICENSE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)
