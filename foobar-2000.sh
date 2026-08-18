#!/bin/bash

# Helper script to start foobar2000 with Wine on Linux with a specific DPI
# stting, which is restored to the default in my system after foobar2000 is
# closed!

export WINEDEBUG="-all"
export WINEPREFIX="/home/vini/wineprefixes/foobar2000"

export FOOBAR_PATH="/home/vini/wineprefixes/foobar2000/drive_c/Program Files (x86)/foobar2000/foobar2000.exe"
export FOOBAR_DEFAULT_DPI=${FOOBAR_DEFAULT_DPI:-192}
export FOOBAR_DPI=${FOOBAR_DPI:-110}

wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d "$FOOBAR_DPI" /f
sleep 3

wine "$FOOBAR_PATH" "$@" &

sleep 5
wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d "$FOOBAR_DEFAULT_DPI" /f
