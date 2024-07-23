#!/bin/bash

LOG_FILE="/var/log/devopsfetch.log"
MAX_LOG_SIZE=$((10 * 1024 * 1024))  # 10MB

# Function to rotate log
rotate_log() {
    if [ -f "$1" ] && [ $(stat -c%s "$1") -ge $MAX_LOG_SIZE ]; then
        mv "$1" "${1}.1"
        touch "$1"
    fi
}

# Main logging loop
while true; do
    rotate_log "$LOG_FILE"
    rotate_log "$DEBUG_LOG_FILE"
    echo "--- $(date) ---" >> "$LOG_FILE"
    echo "--- $(date) ---" >> "$DEBUG_LOG_FILE"
    echo "Running: /usr/local/bin/devopsfetch -p -d -n -u" >> "$DEBUG_LOG_FILE"
    /usr/local/bin/devopsfetch -p -d -n -u >> "$LOG_FILE" 2>> "$DEBUG_LOG_FILE"
    echo "Exit code: $?" >> "$DEBUG_LOG_FILE"
    sleep 60  # Wait for 1 min before next log
done

LOG_FILE="/var/log/devopsfetch.log"

while true; do
    START_TIME=$(date -d '1 hour ago' '+%Y-%m-%d %H:%M:%S')
    END_TIME=$(date '+%Y-%m-%d %H:%M:%S')

    echo "------------ $(date) ------------" >> "$LOG_FILE"
    /usr/local/bin/devopsfetch -t "$START_TIME" "$END_TIME" >> "$LOG_FILE" 2>&1

done
