cmake_minimum_required(VERSION 3.16)

if (${CMAKE_HOST_SYSTEM_NAME} MATCHES "Linux")
    message("-- Building on Linux")

    set(NXDK_LINUX ON)

    set(CMAKE_C_COMPILER "clang")
    set(CMAKE_CXX_COMPILER "clang++")
    set(CMAKE_C_LINK_EXECUTABLE "lld -flavor link <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
    set(CMAKE_CXX_LINK_EXECUTABLE "lld -flavor link <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
#elseif (${CMAKE_HOST_SYSTEM_NAME} MATCHES "Darwin")
#    message("-- Building on MacOS")
#
#    set(NXDK_DARWIN ON)
#
#    set(CMAKE_C_COMPILER "/usr/local/opt/llvm/bin/clang")
#    set(CMAKE_CXX_COMPILER "/usr/local/opt/llvm/bin/clang++")
#    set(CMAKE_C_LINK_EXECUTABLE "/usr/local/opt/llvm/bin/lld -flavor link <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
#    set(CMAKE_CXX_LINK_EXECUTABLE "/usr/local/opt/llvm/bin/lld -flavor link <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
#elseif (${CMAKE_HOST_SYSTEM_NAME} MATCHES "Windows")# AND ${CMAKE_GENERATOR} MATCHES "MinGW Makefiles")
#    message("-- Building on MinGW")
#
#    set(NXDK_MINGW TRUE)
#
#    set(CMAKE_C_COMPILER "clang")
#    set(CMAKE_CXX_COMPILER "clang++")
#    set(CMAKE_C_LINK_EXECUTABLE "lld-link <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
#    set(CMAKE_CXX_LINK_EXECUTABLE "lld-link <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> /out:<TARGET> <LINK_LIBRARIES>")
else()
    message(FATAL_ERROR "Host system '${CMAKE_HOST_SYSTEM_NAME}' or generator '${CMAKE_GENERATOR}' not supported!")
endif()

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

function(add_xbox_executable)
    set(one_value_keywords NAME)
    set(multi_value_keywords SOURCES)
    cmake_parse_arguments(ADD_XBOX_EXECUTABLE "" "${one_value_keywords}" "${multi_value_keywords}" ${ARGN})

    add_executable(${ADD_XBOX_EXECUTABLE_NAME} ${ADD_XBOX_EXECUTABLE_SOURCES})
    target_link_libraries(
        ${ADD_XBOX_EXECUTABLE_NAME}
        nxdk
        ${NXDK_DIR}/lib/xboxkrnl/libxboxkrnl.lib
    )

    set(output_directory ${CMAKE_BINARY_DIR}/bin/${ADD_XBOX_EXECUTABLE_NAME}/)

    set_target_properties(${ADD_XBOX_EXECUTABLE_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${output_directory})
    set(xiso_directory ${output_directory}/xiso)

    add_custom_target(run_cxbe_${ADD_XBOX_EXECUTABLE_NAME}
        ALL
        COMMAND mkdir -p ${xiso_directory}
        COMMAND ${CMAKE_BINARY_DIR}/bin/cxbe -OUT:${xiso_directory}/default.xbe -TITLE:${ADD_XBOX_EXECUTABLE_NAME} ${ADD_XBOX_EXECUTABLE_NAME}
        BYPRODUCTS ${xiso_directory}/${ADD_XBOX_EXECUTABLE_NAME}.xbe
        WORKING_DIRECTORY ${output_directory}
        DEPENDS ${ADD_XBOX_EXECUTABLE_NAME} cxbe
    )

    add_custom_target(run_extract-xiso_${ADD_XBOX_EXECUTABLE_NAME}
        ALL
        COMMAND ${CMAKE_BINARY_DIR}/bin/extract-xiso -c ${xiso_directory} ${ADD_XBOX_EXECUTABLE_NAME}.iso
        BYPRODUCTS ${output_directory}/${ADD_XBOX_EXECUTABLE_NAME}.iso
        WORKING_DIRECTORY ${output_directory}
        DEPENDS run_cxbe_${ADD_XBOX_EXECUTABLE_NAME} extract-xiso
    )
endfunction()

# Libs
option(NXDK_BUILD_LIBS "" ON)
if(NXDK_BUILD_LIBS)
    add_subdirectory(lib)
endif()

# Samples
option(NXDK_BUILD_SAMPLES "" ON)
if (NXDK_BUILD_SAMPLES)
    add_subdirectory(samples)
endif()

# Tools
option(NXDK_BUILD_TOOLS "" ON)
if (NXDK_BUILD_TOOLS)
    # cxbe
    set(CXBE_BINARY_DIR ${CMAKE_BINARY_DIR}/tools/cxbe)
    if (NXDK_MINGW)
        set(CXBE_OPTIONS "-G \"MinGW Makefiles\"")
    endif()
    
    add_custom_target(cxbe
        ALL
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CXBE_BINARY_DIR}
        COMMAND ${CMAKE_COMMAND} -B ${CXBE_BINARY_DIR} ${CXBE_OPTIONS} -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="${CMAKE_BINARY_DIR}/bin" ${CMAKE_CURRENT_LIST_DIR}/tools/cxbe
        COMMAND ${CMAKE_COMMAND} --build ${CXBE_BINARY_DIR}
    )

    # extract-iso
    set(XISO_BINARY_DIR ${CMAKE_BINARY_DIR}/tools/extract-xiso)
    if (NXDK_MINGW)
        set(XISO_OPTIONS "-G \"MinGW Makefiles\"")
    endif()

    add_custom_target(extract-xiso
        ALL
        COMMAND ${CMAKE_COMMAND} -E make_directory ${XISO_BINARY_DIR}
        COMMAND ${CMAKE_COMMAND} -B ${XISO_BINARY_DIR} ${XISO_OPTIONS} -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="${CMAKE_BINARY_DIR}/bin" ${CMAKE_CURRENT_LIST_DIR}/tools/extract-xiso
        COMMAND ${CMAKE_COMMAND} --build ${XISO_BINARY_DIR}
    )
endif()
