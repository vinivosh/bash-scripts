#!/bin/bash

export HOME=${HOME:-/home/vini}
export LOG_FILE="$HOME/.local/share/docker-cleanup.log"

export MSG="$(date --utc +%FT%T.%3NZ) [INFO    ] | Running Docker safe cleanup..."
echo "$MSG" >> "$LOG_FILE"
printf "\n%s\n\n" "$MSG"

docker container prune -f &&
docker image prune -a -f --filter "until=360h" &&
docker builder prune -f &&

export MSG="$(date --utc +%FT%T.%3NZ) [INFO    ] | Docker cleanup completed"
echo "$MSG" >> "$LOG_FILE"
printf "\n%s\n\n" "$MSG"

exit 0