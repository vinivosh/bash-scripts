#!/bin/bash

RCLONE_EXTRA_ARGS=("$@")

export HOME=${HOME:-/home/vini}
export HOSTNAME=$(hostname)

if [ -z "$HOSTNAME" ]; then
    printf "\n\nERROR: hostname couldn't be determined\n\n"
    exit 1
fi

if [[ "$HOSTNAME" == "vini-cos" ]]; then
    export OBSIDIAN_VAULT_PATH="/run/media/vini/Slow/Obsidian/"
    export OBSIDIAN_CONFIG_PATH="$HOME/.config/obsidian/"
elif [[ "$HOSTNAME" == "vini-cos-work" ]]; then
    export OBSIDIAN_VAULT_PATH="$HOME/Documents/Obsidian/"
    export OBSIDIAN_CONFIG_PATH="$HOME/.config/obsidian/"
else
    printf "\n\nERROR: Unexpected hostname! Expected 'vini-cos' or 'vini-pc'\n\n"
    exit 1
fi

# Filter for config files sync
FILTER_FILEPATH="$HOME/scripts/.sync-obsidian.filter.txt"

printf "\n\nSyncing Obsidian vaults...\n"

rclone bisync \
    "$OBSIDIAN_VAULT_PATH" \
    "crypt-b2-vini:Obsidian/" \
    --compare modtime,size --conflict-resolve newer \
    --exclude "*.bzEmpty" --exclude "*.foldersync.old" \
    --resilient --recover \
    --max-lock 2m -MvP --fix-case \
    "${RCLONE_EXTRA_ARGS[@]}" || exit 1

printf "\nSyncing Obsidian config files...\n"

rclone bisync \
    "$OBSIDIAN_CONFIG_PATH" \
    "crypt-b2-vini:dot-config/obsidian/" \
    --compare modtime,size --conflict-resolve newer \
    --filter-from "$FILTER_FILEPATH" \
    --resilient --recover \
    --max-lock 2m -MvP --fix-case \
    "${RCLONE_EXTRA_ARGS[@]}" --force || exit 1


printf "\nObsidian vaults synced successfully.\n\n"
exit 0
