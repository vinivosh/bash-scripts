#!/bin/bash

if pgrep -i "foobar2000\.exe"; then
	echo "Shutting down Foobar2000"
	(
	  ( WINEDEBUG=fixme-all WINEPREFIX=/home/vini/wineprefixes/foobar2000 wine /home/vini/wineprefixes/foobar2000/drive_c/Program\ Files\ \(x86\)/foobar2000/foobar2000.exe /stop ; sleep 0.25 ) &&
	  ( WINEDEBUG=fixme-all WINEPREFIX=/home/vini/wineprefixes/foobar2000 wine /home/vini/wineprefixes/foobar2000/drive_c/Program\ Files\ \(x86\)/foobar2000/foobar2000.exe /exit ; sleep 0.1 )
	)
else
	echo "Foobar2000 is not running, skipping its shutdown"
fi

echo "Shutting down downloaders (torrents, file-sharing, etc.)"
killall -q -w -s TERM qbittorrent &
killall -q -w -s TERM nicotine &
sleep 0.25

echo "Shutting down web browsers"
killall -q -w -s TERM firefox &
killall -q -w -s TERM chromium &
sleep 0.25

echo "Shutting down Steam"
killall -q -w -s TERM steam &
sleep 0.5

echo "Shutting down communication and e-mail apps"
killall -q -w -s TERM discord &
killall -q -w -s TERM equibop &
killall -q -w -s TERM vesktop &
killall -q -w -s TERM Telegram &
killall -q -w -s TERM mailspring &
sleep 0.25

if [[ $1 == "--only-close" ]]; then
	echo "Apps closed, but not shutting down the system, as '--only-close' argument was passed"
    exit 0
fi

if [[ $1 == "-r" ]]; then
	echo "Rebooting in 3 seconds..."
	sleep 3
    systemctl reboot
else
	echo "Shutting down in 3 seconds..."
	sleep 3
    systemctl poweroff
fi

exit 0
