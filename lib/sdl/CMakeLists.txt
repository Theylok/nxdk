# SDL2
file(GLOB sdl2_sources
    SDL2/src/*.c
    SDL2/src/atomic/*.c
    SDL2/src/audio/*.c
    SDL2/src/audio/xbox/*.c
    SDL2/src/cpuinfo/*.c
    SDL2/src/events/*.c
    SDL2/src/file/*.c
    SDL2/src/haptic/*.c
    SDL2/src/haptic/dummy/*.c
    SDL2/src/joystick/*.c
    SDL2/src/joystick/xbox/*.c
    SDL2/src/libm/*.c
    SDL2/src/loadso/dummy/*.c
    SDL2/src/power/*.c
    SDL2/src/filesystem/dummy/*.c
    SDL2/src/render/*.c
    SDL2/src/render/software/*.c
    SDL2/src/sensor/*.c
    SDL2/src/sensor/dummy/*.c
    SDL2/src/stdlib/*.c
    SDL2/src/thread/*.c
    SDL2/src/thread/windows/*.c
    SDL2/src/timer/*.c
    SDL2/src/timer/windows/*.c
    SDL2/src/video/*.c
    SDL2/src/video/xbox/*.c
    SDL2/src/video/yuv2rgb/*.c
)

add_library(SDL2 STATIC ${sdl2_sources})

target_compile_definitions(
    SDL2
    PUBLIC  XBOX
)

target_link_libraries(
    SDL2
    PRIVATE project_options
)

target_include_directories(
    SDL2
    PUBLIC  SDL2/include
)

# freetype
set(freetype_dir "SDL_ttf/external/freetype-2.4.12")

add_library(freetype STATIC
    ${freetype_dir}/src/base/ftbase.c
    ${freetype_dir}/src/base/ftglyph.c
    ${freetype_dir}/src/base/ftbitmap.c
    ${freetype_dir}/src/base/ftstroke.c
    ${freetype_dir}/src/base/ftinit.c
    ${freetype_dir}/src/base/ftsystem.c
    ${freetype_dir}/src/truetype/truetype.c
    ${freetype_dir}/src/raster/raster.c
    ${freetype_dir}/src/smooth/smooth.c
    ${freetype_dir}/src/autofit/autofit.c
    ${freetype_dir}/src/sfnt/sfnt.c
)

target_link_libraries(
    freetype
    PRIVATE project_options
)

target_include_directories(
    freetype
    PUBLIC  .
            ${freetype_dir}/include
)

#SDL_ttf
add_library(SDL_ttf STATIC
    SDL_ttf/SDL_ttf.c
)

target_link_libraries(
    SDL_ttf
    PRIVATE project_options
            freetype
    PUBLIC  SDL2
)

target_include_directories(
    SDL_ttf
    PUBLIC  SDL_ttf
)

# SDL2_image
add_library(SDL2_image STATIC
    SDL2_image/IMG.c
    SDL2_image/IMG_png.c
    SDL2_image/IMG_bmp.c
    SDL2_image/IMG_gif.c
    SDL2_image/IMG_jpg.c
    SDL2_image/IMG_lbm.c
    SDL2_image/IMG_pcx.c
    SDL2_image/IMG_pnm.c
    SDL2_image/IMG_svg.c
    SDL2_image/IMG_tga.c
    SDL2_image/IMG_tif.c
    SDL2_image/IMG_webp.c
    SDL2_image/IMG_WIC.c
    SDL2_image/IMG_xcf.c
    SDL2_image/IMG_xpm.c
    SDL2_image/IMG_xv.c
    SDL2_image/IMG_xxx.c
)

target_compile_definitions(
    SDL2_image
    PUBLIC  LOAD_BMP
            LOAD_GIF
            LOAD_JPG
            LOAD_LBM
            LOAD_PCX
            LOAD_PNG
            LOAD_PNM
            LOAD_TGA
            LOAD_XCF
            LOAD_XPM
            LOAD_XV
            LOAD_XXX
)

target_link_libraries(
    SDL2_image
    PRIVATE project_options
            libjpeg
            libpng
    PUBLIC  SDL2
)

target_include_directories(
    SDL2_image
    PUBLIC  SDL2_image
)
