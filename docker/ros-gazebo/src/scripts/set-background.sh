#!/bin/bash
###
### Configures the XFCE desktop for a minimal, dark appearance.
### Runs as an autostart entry after the XFCE session initializes.
###
### Supports CUSTOM_BACKGROUND environment variable:
###   export CUSTOM_BACKGROUND=/path/to/image.png
###   (mount the image into the container)
###

### Wait for xfdesktop to initialize and register its properties
sleep 3

### Discover the monitor property path dynamically.
### The VNC monitor name varies (e.g., VNC-0, screen, etc.),
### so we detect it from xfdesktop's registered properties.
MONITOR_PATH=$(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep -m1 "workspace0" | sed 's|/[^/]*$||')

if [ -z "$MONITOR_PATH" ]; then
    ### Fallback: try to find any backdrop property
    MONITOR_PATH=$(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep -m1 "backdrop" | sed 's|/[^/]*$||')
fi

if [ -n "$MONITOR_PATH" ]; then
    if [ -n "$CUSTOM_BACKGROUND" ] && [ -f "$CUSTOM_BACKGROUND" ]; then
        ### Use custom background image (zoomed to fill)
        xfconf-query -c xfce4-desktop -p "${MONITOR_PATH}/image-style" -s 5 --create -t int
        xfconf-query -c xfce4-desktop -p "${MONITOR_PATH}/last-image" -s "$CUSTOM_BACKGROUND" --create -t string
    else
        ### Solid dark background color (#1a1a2e)
        xfconf-query -c xfce4-desktop -p "${MONITOR_PATH}/image-style" -s 0 --create -t int
        xfconf-query -c xfce4-desktop -p "${MONITOR_PATH}/color-style" -s 0 --create -t int
        xfconf-query -c xfce4-desktop -p "${MONITOR_PATH}/rgba1" \
            -s 0.101961 -s 0.101961 -s 0.180392 -s 1.000000 \
            --create -t double -t double -t double -t double
    fi
fi

### Disable desktop icons
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0 --create -t int
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -s false --create -t bool
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -s false --create -t bool
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -s false --create -t bool
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s false --create -t bool

### Disable desktop right-click menu
xfconf-query -c xfce4-desktop -p /desktop-menu/show -s false --create -t bool

exit 0
