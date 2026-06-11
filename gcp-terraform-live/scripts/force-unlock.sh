#!/bin/bash
set -e

STATE_FILE=$1
LOCK_ID=$2

if [ -z "$STATE_FILE" ] || [ -z "$LOCK_ID" ]; then
  echo "Usage: force-unlock.sh <state-file> <lock-id>"
  exit 1
fi

terraform force-unlock "$LOCK_ID" "$STATE_FILE"
