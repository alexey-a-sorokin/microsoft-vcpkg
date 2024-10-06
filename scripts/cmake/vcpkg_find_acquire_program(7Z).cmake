set(program_name 7z2408)
if(CMAKE_HOST_WIN32)
    set(tool_subdirectory "24.08")
    set(paths_to_search "${DOWNLOADS}/tools/7z/${tool_subdirectory}/Files/7-Zip")
    list(APPEND paths_to_search "${DOWNLOADS}/tools/7z/${tool_subdirectory}/")
    set(download_urls "https://github.com/ip7z/7zip/releases/download/24.08/7z2408.exe")
    set(download_filename "7z2408.7z.exe")
    set(download_sha512 "7f6c46c780fcb5fc10cc5405221179ddecbbb871c578ca3d9e3a74141271b383bd83e8f9d75c98d7e9d406e9b935d52a6b04913d654169e0b30f0719225e7dd9")

    # Loop through paths_to_search, list files, and print them
    foreach(path IN LISTS paths_to_search)
        message(STATUS "Searching path: ${path}")

        # Use file(GLOB ...) to get all files and directories in the current path
        file(GLOB contents "${path}/*")

        # Print each file or directory in the path
        foreach(file IN LISTS contents)
            message(STATUS "Found: ${file}")
        endforeach()
    endforeach()
endif()