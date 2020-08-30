add_library(nxdk STATIC
    mount.c
    path.c

)

target_link_libraries(
    nxdk
    PUBLIC  project_options
            hal
            libc++
            libjpeg
            libpng
            net
            pbkit
            pdclib
            SDL2
            SDL_ttf
            SDL2_image
            usb
            winapi
            xboxrt
)
