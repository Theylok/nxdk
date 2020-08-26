add_library(hal STATIC
    audio.c
    debug.c
    fileio.c
    input.c
    io.c
    led.c
    video.c
    xbox.c
)

target_link_libraries(
    hal
    PRIVATE project_options
)
