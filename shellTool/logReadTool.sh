#!/bin/bash
set -e

#LOG_FILE="/mnt/c/Users/Jan/Desktop/2025hw/shellTool/logs.log"
LOG_FILE=$1
#LOG_COUNT=grep -v '^$' $LOG_FILE | wc -l 
LOG_COUNT=$(grep -c '^[^#]' $LOG_FILE)

#LOG_HOST="debian"
LOG_HOST=$2

#LOG_PORT=514
LOG_PORT=$3

echo "$LOG_COUNT log lines found"

COUNT=1
## In the example log lines, the last line is not properly terminated, might be part of the task?
while IFS= read -r line || [ -n "$line" ]; do
    if [ -z "$line" ]; then
    continue
    fi
    echo "Read line: $COUNT"
    logger -n $LOG_HOST -P $LOG_PORT "$line"
    echo "Sent line: $COUNT"
    ((COUNT++))

done < $LOG_FILE