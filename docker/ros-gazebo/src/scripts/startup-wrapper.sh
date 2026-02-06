#!/bin/bash
###
### Wrapper script that auto-detects display mode:
###   - If DISPLAY is set (host X11): skip VNC, use host display
###   - If DISPLAY is not set: start VNC server on VNC_DISPLAY (default :1)
###
### Usage:
###   VNC mode (default):   docker run -p 5901:5901 -p 6901:6901 image
###   Host X11 mode:        docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix image
###

if [ -z "$DISPLAY" ]; then
    ### No display provided - start VNC server
    export DISPLAY="${VNC_DISPLAY:-:1}"
    exec /dockerstartup/startup.sh "$@"
else
    ### External display provided (host X11) - skip VNC
    echo "Using host display: $DISPLAY (VNC server disabled)"
    exec /dockerstartup/startup.sh --skip-vnc "$@"
fi
