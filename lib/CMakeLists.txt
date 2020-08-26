add_subdirectory(hal)
add_subdirectory(libjpeg)
add_subdirectory(libpng)
add_subdirectory(nxdk)
add_subdirectory(pbkit)

#pdclib
file(GLOB_RECURSE pdclib_c_files
    pdclib/functions/*.c
    pdclib/platform/xbox/*.c
)
    
file(GLOB_RECURSE pdclib_asm_files
    pdclib/platform/xbox/*.s
)

add_library(pdclib STATIC ${pdclib_c_files} ${pdclib_asm_files})

set_property(SOURCE ${pdclib_asm_files} PROPERTY LANGUAGE C)

target_link_libraries(
    pdclib
    PRIVATE project_options
)

add_subdirectory(sdl)
add_subdirectory(winapi)
add_subdirectory(xboxrt)
add_subdirectory(zlib)
