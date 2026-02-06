#! /bin/bash
# shellcheck disable=SC2034

# Size of the screen. If not set gamescope will detect native resolution from drm.
SCREEN_WIDTH=1920
SCREEN_HEIGHT=1080

# Internal render size of the screen. If not set, will be the same as SCREEN_HEIGHT and SCREEN_WIDTH.
INTERNAL_WIDTH=1920
INTERNAL_HEIGHT=1080

# Orientation adjustment of panel, possible values: left, right
ORIENTATION=left

# 1 = Enable VRR, 0 = Disable VRR
ADAPTIVE_SYNC=0

# Treat the internal panel as an external monitor
PANEL_TYPE=external

# Set priority of display connectors
OUTPUT_CONNECTOR='HDMI-A-1,DP-2'
# CONNECTOR='HDMI-A-1,DP-2'

# Set the specific values allowed for refresh rates
CUSTOM_REFRESH_RATES=30,60

# Set the range of the refresh rate slider in the Steam client
export STEAM_DISPLAY_REFRESH_LIMITS=30,60

# TODO: document
DRM_MODE=fixed

# Specify if you want to enable support for HDR content
# ENABLE_GAMESCOPE_HDR=1
# Set the target luminace of the inverse tone mapping process (option)
# GAMESCOPE_HDR_NITS=400

# Override entire client command line
# CLIENTCMD="steam -steamos -pipewire-dmabuf -gamepadui"

# # Override the entire Gamescope command line
# # This will not use screen and render sizes above
# GAMESCOPECMD="gamescope -e -f"

GAMESCOPECMD="\
gamescope \
    --steam --mangoapp \
    --xwayland-count 2 \
    --fullscreen \
    --nested-refresh 60 \
    -W $SCREEN_WIDTH -H $SCREEN_HEIGHT -w $INTERNAL_WIDTH -h $INTERNAL_HEIGHT \
    --prefer-output $OUTPUT_CONNECTOR \
"

# gamescope \
#     --steam --mangoapp \
#     --hdr-enabled --hdr-itm-enable \
#     --fullscreen \
#     -W $SCREEN_WIDTH -H $SCREEN_HEIGHT -w $INTERNAL_WIDTH -h $INTERNAL_HEIGHT \
#     --hide-cursor-delay 5000 --fade-out-duration 200 \
#     --prefer-output $OUTPUT_CONNECTOR \
#     -- steam -bigpicture

gamescope-session-plus steam -steamos -pipewire-dmabuf -gamepadui
