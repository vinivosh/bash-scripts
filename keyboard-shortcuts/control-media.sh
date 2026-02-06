#!/bin/bash

# ? ############################################################################
# A simple script to control media playback. Will always control foobar2000 with
# wine if it is running. Otherwise, it will fallback to using playerctl to
# control any media players that support it.
#
# Usage: ./control-media.sh [--play | --pause | --next | --previous | --stop]
# ? ############################################################################

export WINEDEBUG="-all"
export WINEPREFIX="$HOME/wineprefixes/foobar2000"

FOOBAR_PATH="$HOME/wineprefixes/foobar2000/drive_c/Program Files (x86)/foobar2000/foobar2000.exe"

# Parse command arguments
case "$1" in
    --play)
        # Toggling play/pause is the intended behaviour here. I honestly never use the proper play command itself...
        COMMAND="/pause"
        COMMAND_FALLBACK="play-pause"
        ;;
    --pause)
        COMMAND="/pause"
        COMMAND_FALLBACK="play-pause"
        ;;
    --stop)
        COMMAND="/stop"
        COMMAND_FALLBACK="stop"
        ;;
    --next)
        COMMAND="/next"
        COMMAND_FALLBACK="next"
        ;;
    --previous)
        COMMAND="/prev"
        COMMAND_FALLBACK="previous"
        ;;
    "")
        # Default to pause if no argument provided
        COMMAND="/pause"
        COMMAND_FALLBACK="play-pause"
        ;;
    *)
        echo "Usage: $0 [--play | --pause | --next | --previous | --stop]"
        exit 1
        ;;
esac

# Execute the command if foobar2000 is running
if pgrep -i "foobar2000\.exe" > /dev/null 2>&1; then
    wine "$FOOBAR_PATH" "$COMMAND"
else
    # Fallback to playerctl if foobar2000 isn't running, in case there is any
    # other media playing. If playerctl isn't installed, do nothing
    if command -v playerctl &> /dev/null; then
        playerctl "$COMMAND_FALLBACK" --player=all
    else
        exit 1
    fi
fi
