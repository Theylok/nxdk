add_subdirectory(hal)

#libcxx
add_library(libc++ STATIC
    libcxx/src/algorithm.cpp
    libcxx/src/any.cpp
    libcxx/src/bind.cpp
    libcxx/src/charconv.cpp
    libcxx/src/chrono.cpp
    libcxx/src/condition_variable.cpp
    libcxx/src/condition_variable_destructor.cpp
    libcxx/src/debug.cpp
    libcxx/src/exception.cpp
    libcxx/src/functional.cpp
    libcxx/src/future.cpp
    libcxx/src/hash.cpp
    libcxx/src/ios.cpp
    libcxx/src/iostream.cpp
    libcxx/src/locale.cpp
    libcxx/src/memory.cpp
    libcxx/src/mutex.cpp
    libcxx/src/mutex_destructor.cpp
    libcxx/src/new.cpp
    libcxx/src/optional.cpp
    libcxx/src/random.cpp
    libcxx/src/regex.cpp
    libcxx/src/shared_mutex.cpp
    libcxx/src/stdexcept.cpp
    libcxx/src/string.cpp
    libcxx/src/strstream.cpp
    libcxx/src/system_error.cpp
    libcxx/src/thread.cpp
    libcxx/src/typeinfo.cpp
    libcxx/src/utility.cpp
    libcxx/src/valarray.cpp
    libcxx/src/variant.cpp
    libcxx/src/vector.cpp
    libcxx/src/support/win32/support.cpp
    libcxx/src/support/win32/thread_win32.cpp
)

target_link_libraries(
    libc++
    PRIVATE project_options
)

target_include_directories(
    libc++
    PUBLIC  libcxx/include
)

add_subdirectory(libjpeg)
add_subdirectory(libpng)
add_subdirectory(net)
add_subdirectory(nxdk)
add_subdirectory(pbkit)

#pdclib
file(GLOB_RECURSE pdclib_c_files
    pdclib/functions/*.c
    pdclib/platform/xbox/*.c
)
    
file(GLOB_RECURSE pdclib_asm_files
    pdclib/platform/xbox/*.s
)

add_library(pdclib STATIC ${pdclib_c_files} ${pdclib_asm_files})

set_property(SOURCE ${pdclib_asm_files} PROPERTY LANGUAGE C)

target_link_libraries(
    pdclib
    PRIVATE project_options
)

add_subdirectory(sdl)
add_subdirectory(usb)
add_subdirectory(winapi)
add_subdirectory(xboxrt)
add_subdirectory(zlib)
