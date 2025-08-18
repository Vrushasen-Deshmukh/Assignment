#!/bin/bash
# backup.sh - log timestamp when run

# Get current date and time
CURRENT_DATE=$(date "+%Y-%m-%d")
CURRENT_TIME=$(date "+%H:%M:%S")

# Print message
echo "Backup file ran on $CURRENT_DATE at $CURRENT_TIME"
