#!/bin/bash

# =========================
# CloudTrail Lookup Script
# =========================

USERNAME=$1
START_TIME=$2
END_TIME=$3
OUTPUT_FILE=${4:-events.json}

if [ -z "$USERNAME" ] || [ -z "$START_TIME" ] || [ -z "$END_TIME" ]; then
  echo "Usage: $0 <username> <start-time> <end-time> [output-file]"
  echo "Example: $0 john 2026-05-15T00:00:00Z 2026-05-18T00:00:00Z events.json"
  exit 1
fi

# https://docs.aws.amazon.com/cli/latest/reference/cloudtrail/lookup-events.html
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=Username,AttributeValue="$USERNAME" \
  --start-time "$START_TIME" \
  --end-time "$END_TIME" \
  --output json > "$OUTPUT_FILE"

echo "Saved results to $OUTPUT_FILE"
