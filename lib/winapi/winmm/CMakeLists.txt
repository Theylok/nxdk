add_library(winmm STATIC
    timeapi.c
)

target_link_libraries(
    winmm
    PRIVATE project_options
)

target_include_directories(
    winmm
    PUBLIC .
)
