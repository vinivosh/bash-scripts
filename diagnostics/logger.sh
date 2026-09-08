#!/bin/bash
#
# Lightweight system telemetry logger for diagnosing sudden hard reboots. Runs independently of
# journald/pstore so data survives even when a hard reset skips a clean shutdown entirely — every sample is
# fsync'd to disk immediately, since anything left in page cache is lost on a hard reset.

set -u

LOG_DIR="$HOME/scripts/diagnostics/logs"
INTERVAL=5
RETENTION_DAYS=7

mkdir -p "$LOG_DIR"

log_sample() {
    local log_file="$LOG_DIR/$(date +%Y-%m-%d).log"

    {
        echo "===== $(date '+%Y-%m-%d %H:%M:%S') ====="

        echo "--- memory ---"
        free -h

        echo "--- swap devices ---"
        swapon --show

        echo "--- load ---"
        uptime

        echo "--- top memory consumers ---"
        ps -eo pid,comm,%mem,rss --sort=-%mem --no-headers | head -8

        if command -v sensors &>/dev/null; then
            echo "--- temps ---"
            sensors
        fi

        if command -v upower &>/dev/null; then
            bat="$(upower -e 2>/dev/null | grep -m1 'BAT')"
            if [[ -n "$bat" ]]; then
                echo "--- battery ---"
                upower -i "$bat" | grep -E "state|percentage|energy-rate|warning-level"
            fi
        fi

        printf "\n\n"
    } >> "$log_file"

    sync -d "$log_file"
}

echo "Logging every ${INTERVAL}s to $LOG_DIR (retention: ${RETENTION_DAYS}d). Ctrl+C to stop."

find "$LOG_DIR" -name '*.log' -mtime "+$RETENTION_DAYS" -delete

trap 'exit 0' SIGINT SIGTERM

while true; do
    log_sample
    sleep "$INTERVAL"
done
