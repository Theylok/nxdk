add_library(usb STATIC
    host/ohci-hcd.c
    core/message.c
    core/hcd.c
    core/hcd-pci.c
    core/hub.c
    core/usb.c
    core/config.c
    core/urb.c
    core/buffer_simple.c
    core/usb-debug.c
    sys/BootUSB.c
    sys/linuxwrapper.c
    sys/xpad.c
    sys/xremote.c
    sys/usbkey.c
    sys/usbmouse.c
    misc/misc.c
    misc/pci.c
    misc/malloc.c
)

target_link_libraries(
    usb
    PRIVATE project_options
)
