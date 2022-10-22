_find_package(X11 COMPONENTS Xau Xdmcp)
_find_package(${ARGS})
if(TARGET XCB::XCB)
    if(TARGET X11::Xdmcp)
        target_link_libraries(XCB::XCB INTERFACE X11::Xdmcp)
    endif()
    if(TARGET X11::Xau)
        target_link_libraries(XCB::XCB INTERFACE X11::Xau)
    endif()
endif()
if(TARGET XCB::IMAGE)
    if(TARGET XCB::UTIL)
        target_link_libraries(XCB::IMAGE INTERFACE XCB::UTIL)
    endif()
endif