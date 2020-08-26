set(xboxrt_asm_files
    c_runtime/_alldiv.s
    c_runtime/_allmul.s
    c_runtime/_allrem.s
    c_runtime/_allshl.s
    c_runtime/_allshr.s
    c_runtime/_aulldiv.s
    c_runtime/_aullrem.s
    c_runtime/_aullshl.s
    c_runtime/_aullshr.s
    c_runtime/chkstk.s
)

add_library(xboxrt STATIC
    libc_extensions/stat.c
    libc_extensions/strings.c
    libc_extensions/wchar.c
    libc_extensions/wchar_ext_.c
    libc_extensions/wctype_ext_.c
    libc_extensions/stdlib_ext_.c
    libc_extensions/string_ext_.c
    c_runtime/_fltused.c
    c_runtime/check_stack.c
    vcruntime/purecall.c
    vcruntime/threadsafe_statics.c
    vcruntime/vcruntime_exception.cpp
    vcruntime/vcruntime_typeinfo.cpp
    vcruntime/eh.cpp
    ${xboxrt_asm_files}
)

set_source_files_properties(vcruntime/vcruntime_typeinfo.cpp PROPERTIES COMPILE_FLAGS -fno-rtti)
set_source_files_properties(${xboxrt_asm_files} PROPERTIES LANGUAGE C)

target_link_libraries(
    xboxrt
    PRIVATE project_options
)
