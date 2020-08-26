add_subdirectory(winmm)

add_library(winapi STATIC
    badptr.c
    debug.c
    errhandlingapi.c
    error.c
    fiber.c
    fileio.c
    filemanip.c
    findfile.c
    handleapi.c
    memory.c
    libloaderapi.c
    profiling.c
    shlobj_core.c
    sync.c
    sysinfo.c
    thread.c
    tls.c
)

target_link_libraries(
    winapi
    PRIVATE project_options
    PUBLIC  winmm
)
