cmake_minimum_required(VERSION 3.16)

set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_C_LINK_EXECUTABLE "lld -flavor link <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
set(CMAKE_CXX_LINK_EXECUTABLE "lld -flavor link <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")

project(NXDK LANGUAGES C CXX)

set(NXDK_DIR ${CMAKE_CURRENT_LIST_DIR})

add_library(project_options INTERFACE)

target_compile_options(
    project_options
    INTERFACE   -target i386-pc-win32
                -march=pentium3
                -ffreestanding
                -nostdlib
                -fno-builtin
                -fno-exceptions
                -Wno-ignored-attributes
)

target_compile_definitions(
    project_options
    INTERFACE   NXDK
                __STDC__=1
)

target_link_options(
    project_options
    INTERFACE   -subsystem:windows
                -fixed:no
                -entry:XboxCRTEntry
                -stack:65536
                -safeseh:no
                -include:__fltused
                -include:__xlibc_check_stack
)

target_include_directories(
    project_options
    INTERFACE   lib
                lib/xboxrt/libc_extensions
                lib/hal
                lib/pdclib/include
                lib/pdclib/platform/xbox/include
                lib/winapi
                lib/xboxrt/vcruntime
)

function(add_xbox_executable name sources)
    add_executable(${name} ${sources})
    target_link_libraries(
        ${name}
        nxdk
        ${NXDK_DIR}/lib/xboxkrnl/libxboxkrnl.lib
    )
endfunction()

# Libs
add_subdirectory(lib)

# Samples
option(NXDK_BUILD_SAMPLES OFF)
if (NXDK_BUILD_SAMPLES)
    add_subdirectory(samples)
endif()
