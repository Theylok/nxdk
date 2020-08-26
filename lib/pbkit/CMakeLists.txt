add_library(pbkit STATIC
    pbkit.c
)

target_link_libraries(
    pbkit
    PRIVATE project_options
)
