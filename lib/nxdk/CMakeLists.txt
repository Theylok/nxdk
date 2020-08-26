add_library(nxdk STATIC
    mount.c
    path.c

)

target_link_libraries(
    nxdk
    PUBLIC  project_options
            hal
            libjpeg
            libpng
            pbkit
            pdclib
            SDL2
            SDL_ttf
            SDL2_image
            winapi
            xboxrt
)
