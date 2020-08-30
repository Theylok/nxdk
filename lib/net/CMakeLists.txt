set(LWIP_DIR ${CMAKE_CURRENT_LIST_DIR}/lwip)
include(lwip/src/Filelists.cmake)

add_library(net STATIC
    ${lwipcore_SRCS}
    ${lwipcore4_SRCS}
    ${lwipcore6_SRCS}
    ${LWIP_DIR}/src/netif/ethernet.c
    ${LWIP_DIR}/src/netif/bridgeif.c
    ${LWIP_DIR}/src/netif/bridgeif_fdb.c
    ${lwipapi_SRCS}
    nforceif/src/driver.c
    nforceif/src/sys_arch.c
    pktdrv/pktdrv.c
)

target_link_libraries(
    net
    PRIVATE project_options
)

target_include_directories(
    net
    PUBLIC  lwip/src/include
            nforceif/include
            pktdrv
)
