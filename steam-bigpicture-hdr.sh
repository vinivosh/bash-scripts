#! /bin/bash
# shellcheck disable=SC2034

# Orientation adjustment of panel, possible values: left, right
ORIENTATION=left

# Enable VRR
ADAPTIVE_SYNC=1

# Treat the internal panel as an external monitor
PANEL_TYPE=external

# Set the specific values allowed for refresh rates
CUSTOM_REFRESH_RATES=30,60

# Set the range of the refresh rate slider in the Steam client
export STEAM_DISPLAY_REFRESH_LIMITS=30,60

# TODO: document
DRM_MODE=fixed

# Specify if you want to enable support for HDR content
ENABLE_GAMESCOPE_HDR=1
# Set the target luminace of the inverse tone mapping process (option)
GAMESCOPE_HDR_NITS=400

# # Override entire client command line
# # CLIENTCMD="steam -steamos -pipewire-dmabuf -gamepadui"

# # Override the entire Gamescope command line
# # This will not use screen and render sizes above
# # GAMESCOPECMD="gamescope -e -f"
# # GAMESCOPECMD="\
# # gamescope --steam --fullscreen --mangoapp --hdr-enabled --hdr-itm-enable \
# # --hide-cursor-delay 5000 --fade-out-duration 200 --xwayland-count 2 \
# # -W $SCREEN_WIDTH -H $SCREEN_HEIGHT -w $INTERNAL_WIDTH -h $INTERNAL_HEIGHT \
# # --prefer-output $OUTPUT_CONNECTOR \
# # "

# gamescope-session-plus steam -steamos -pipewire-dmabuf -gamepadui

################################################################################

# Size of the screen. If not set gamescope will detect native resolution from drm.
SCREEN_WIDTH=3840
SCREEN_HEIGHT=2160

# Internal render size of the screen. If not set, will be the same as SCREEN_HEIGHT and SCREEN_WIDTH.
INTERNAL_WIDTH=1920
INTERNAL_HEIGHT=1080

# Set priority of display connectors
OUTPUT_CONNECTOR='HDMI-A-1,DP-2'

# # Disables Steam screen recording which causes FPS to tank sometimes
# LD_PRELOAD=""

# Env vars for full HDR support?
ENABLE_HDR_WSI=1
DXVK_HDR=1
# DISPLAY=:1

# Settings suggested in:
# https://www.protondb.com/app/1888930#RVpadpOMP0
# DISPLAY=""
# LD_PRELOAD=""
DXVK_HDR=1
ENABLE_HDR_WSI=1
PROTON_FORCE_NVAPI=1
DXVK_NVAPI_GPU_ARCH=GA100
# WINEDLLOVERRIDES="amd_ags_x64.dll=b"

PROTON_ENABLE_WAYLAND=1
PROTON_ENABLE_HDR=1

# DISPLAY="" LD_PRELOAD="" DXVK_HDR=1 ENABLE_HDR_WSI=1 PROTON_FORCE_NVAPI=1 DXVK_NVAPI_GPU_ARCH=GA100 %command% skiplogos

gamescope \
    --steam --mangoapp \
    --hdr-enabled --hdr-itm-enabled \
    --fullscreen \
    --scaler integer --filter nearest \
    --nested-refresh 60 \
    -W $SCREEN_WIDTH -H $SCREEN_HEIGHT -w $INTERNAL_WIDTH -h $INTERNAL_HEIGHT \
    --hide-cursor-delay 3000 --fade-out-duration 200 \
    --prefer-output $OUTPUT_CONNECTOR \
    -- steam -bigpicture -gamepadui

    # -- steam-native -bigpicture -pipewire-dmabuf -gamepadui
