add_library(zlib STATIC
    zlib/adler32.c
    zlib/crc32.c
    zlib/deflate.c
    zlib/infback.c
    zlib/inffast.c
    zlib/inflate.c
    zlib/inftrees.c
    zlib/trees.c
    zlib/zutil.c
)

target_compile_definitions(
    zlib
    PUBLIC Z_SOLO
)

target_link_libraries(
    zlib
    PRIVATE project_options
)

target_include_directories(
    zlib
    PUBLIC zlib
)
