#!/bin/bash

# ? ############################################################################
# A simple script to control the screen on/off state with `kscreen-doctor` +
# optionally locking your session with `loginctl`. Controls all enabled screens
# together. Useful for use with KDE Plasma 6's keyboard shortcuts setup.
#
# Usage: ./control-screen.sh [--on | --off | --toggle | --lock]
#
#   --on: Turns the screen(s) on immediately
#   --off: Turns the screen(s) off after a short delay to stop accidentally
#     turning it on again with a key press or mouse movement
#   --toggle: if screen(s) is on, equivalent to --off; if screen(s) is off,
#     equivalent to --on
#   --lock: Locks the session immediately and turns the screen(s) off after 5s
# ? ############################################################################

# Parse command arguments
case "$1" in
    --on)
        kscreen-doctor --dpms on &
        exit 0
        ;;
    --off)
        sleep 0.5 && kscreen-doctor --dpms off
        exit 0
        ;;
    --toggle)
        if kscreen-doctor --dpms show | grep -q ": on"; then
            sleep 0.5 && kscreen-doctor --dpms off
            exit 0
        elif kscreen-doctor --dpms show | grep -q ": off"; then
            kscreen-doctor --dpms on &
            exit 0
        else
            echo "Error: couldn't determine the current DPMS state of the screen(s)."
            exit 1
        fi
        ;;
    --lock)
        loginctl lock-session && sleep 5.0 && kscreen-doctor --dpms off
        exit 0
        ;;
    *)
        echo "Usage: $0 --on | --off | --toggle | --lock"
        exit 1
        ;;
esac