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

    set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${name})
    get_target_property(output_directory ${name} RUNTIME_OUTPUT_DIRECTORY)
    set(xiso_directory ${output_directory}/xiso)

    add_custom_target(build_xbe
        ALL
        COMMAND mkdir -p ${xiso_directory}
        COMMAND ${CMAKE_BINARY_DIR}/bin/cxbe -OUT:${xiso_directory}/${name}.xbe -TITLE:${name} ${name}
        BYPRODUCTS ${xiso_directory}/${name}.xbe
        WORKING_DIRECTORY ${output_directory}
    )

    add_dependencies(build_xbe ${name})

    add_custom_target(build_xiso
        ALL
        COMMAND ${CMAKE_BINARY_DIR}/bin/extract-xiso -c ${xiso_directory} ${name}.iso
        BYPRODUCTS ${output_directory}/${name}.iso
        WORKING_DIRECTORY ${output_directory}
    )

    add_dependencies(build_xiso build_xbe)
endfunction()

# Libs
add_subdirectory(lib)

# Samples
option(NXDK_BUILD_SAMPLES OFF)
if (NXDK_BUILD_SAMPLES)
    add_subdirectory(samples)
endif()

# Tools
set(TOOLS_BINARY_DIR ${CMAKE_BINARY_DIR}/tools/)

add_custom_target(tools
    ALL
    COMMAND mkdir -p ${TOOLS_BINARY_DIR}
    COMMAND cmake -B ${TOOLS_BINARY_DIR} -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="${CMAKE_BINARY_DIR}/bin" ${CMAKE_CURRENT_LIST_DIR}/tools/
    COMMAND cmake --build ${TOOLS_BINARY_DIR} -- -j1
)
