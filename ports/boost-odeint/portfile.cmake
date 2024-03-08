# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/odeint
    REF boost-${VERSION}
    SHA512 ea48b08fe00b9075af80f6f2614a639fd84b146ecfed229ae2ce23745a6a6d85b4d607ee2b199134848c87562ef8145aba0ff063a862653b3f01512de5717234
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
