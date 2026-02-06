#!/bin/bash

echo 'Syncing RetroArch saves folder'

rclone bisync ~/.config/retroarch/saves/ b2-vini:vinicius7427-backup-games/RetroArch/saves/ --compare modtime,size,checksum --conflict-resolve newer --exclude "*.bzEmpty" --exclude "*.foldersync.old" --create-empty-src-dirs --slow-hash-sync-only --resilient --recover --max-lock 2m -MvP --fix-case &&

echo 'Syncing RetroArch states folder'

rclone bisync ~/.config/retroarch/states/ b2-vini:vinicius7427-backup-games/RetroArch/states/ --compare modtime,size,checksum --conflict-resolve newer --exclude "*.bzEmpty" --exclude "*.foldersync.old" --create-empty-src-dirs --slow-hash-sync-only --resilient --recover --max-lock 2m -MvP --fix-case

# TODO: PS2 saves?

echo 'Syncing RetroArch shaders/custom folder'

rclone bisync ~/.config/retroarch/shaders/custom/ b2-vini:vinicius7427-backup-games/RetroArch/custom_shaders/ --compare modtime,size,checksum --conflict-resolve newer --exclude "*.bzEmpty" --exclude "*.foldersync.old" --create-empty-src-dirs --slow-hash-sync-only --resilient --recover --max-lock 2m -MvP --fix-case
