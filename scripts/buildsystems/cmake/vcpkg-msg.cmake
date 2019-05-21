option(VCPKG_VERBOSE "Enables messages from the VCPKG toolchain for debugging purposes." ON)
mark_as_advanced(VCPKG_VERBOSE)

option(VCPKG_ERROR_TO_WARNING "Reduces vcpkg message mode from FATAL_ERROR to WARNING." OFF)
mark_as_advanced(VCPKG_FATAL_ERROR_TO_WARNING)

option(VCPKG_WARNING_TO_ERROR "Escalates vcpkg message mode from WARNING to FATAL_ERROR." OFF)
mark_as_advanced(VCPKG_WARNING_TO_ERROR)

function(vcpkg_msg _mode _function _message)
    cmake_parse_arguments(PARSE_ARGV 3 vcpkg-msg "ALWAYS" "" "")
    if(VCPKG_VERBOSE OR vcpkg-msg_ALWAYS)
        if(${_mode} STREQUAL FATAL_ERROR AND VCPKG_ERROR_TO_WARNING)
            message(WARNING "VCPKG-${_function}: ${_message}")
        elseif((${_mode} STREQUAL WARNING OR ${_mode} STREQUAL AUTHOR_WARNING) AND VCPKG_WARNING_TO_ERROR)
            message(FATAL_ERROR "VCPKG-${_function}: ${_message}")
        else()
            message(${_mode} "VCPKG-${_function}: ${_message}")
        endif()
    endif()
endfunction()