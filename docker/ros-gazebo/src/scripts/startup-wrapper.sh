#!/bin/bash
###
### Wrapper script that starts VNC always, while also preserving host X11 display.
###
### Display modes:
###   DISPLAY=:10         -> VNC/noVNC (ports 5900/6901) - always active
###   HOST_DISPLAY=:0     -> host X11 (set when container is launched with -e DISPLAY)
###
### Usage:
###   VNC only:      docker run -p 5900:5900 -p 6901:6901 image
###   VNC + host X11: docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
###                              -p 5900:5900 -p 6901:6901 image
###
### Inside the container:
###   DISPLAY=$DISPLAY rviz2          -> renders in VNC
###   DISPLAY=$HOST_DISPLAY rviz2     -> renders on host physical monitor
###

if [ -n "$DISPLAY" ]; then
    ### Save host display before overriding
    export HOST_DISPLAY="${DISPLAY}"
    echo "Host display saved as HOST_DISPLAY=${HOST_DISPLAY}"
fi

### Always start VNC on :10 (avoids collision with host X sockets bind-mounted via /tmp/.X11-unix)
export DISPLAY="${VNC_DISPLAY:-:10}"
exec /dockerstartup/startup.sh "$@"
