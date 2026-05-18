#!/bin/bash

# =========================
# CloudTrail Investigation Script
# =========================

USERNAME=$1
START_TIME=$2
END_TIME=$3
OUTPUT_FILE=${4:-events.json}

if [ -z "$USERNAME" ] || [ -z "$START_TIME" ] || [ -z "$END_TIME" ]; then
  echo "Usage: $0 <username> <start-time> <end-time> [output-file]"
  exit 1
fi

echo "[+] Running CloudTrail lookup..."

# https://docs.aws.amazon.com/cli/latest/reference/cloudtrail/lookup-events.html
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=Username,AttributeValue="$USERNAME" \
  --start-time "$START_TIME" \
  --end-time "$END_TIME" \
  --output json > "$OUTPUT_FILE"

echo "[+] Saved CloudTrail events to $OUTPUT_FILE"

# Extract IPs FROM SAVED OUTPUT-FILE
echo "[+] Extracting IP addresses..."

IPS_FILE="ips.txt"

jq -r '
  .Events[]
  | (.CloudTrailEvent | fromjson? | .sourceIPAddress // empty)
' "$OUTPUT_FILE" | sort | uniq > "$IPS_FILE"

echo "[+] Unique IPs saved to $IPS_FILE"

# IPs LOOKUP WITH `http://ip-api.com  
echo "[+] IP Lookup data..."

IP_LOOKUP_FILE="ip-lookup.txt"
> "$IP_LOOKUP_FILE"

while read -r ip; do
  echo "=== $ip ===" | tee -a "$IP_LOOKUP_FILE"

  curl -s "http://ip-api.com/json/$ip" | jq '{
    query,
    country,
    regionName,
    city,
    isp
  }' | tee -a "$IP_LOOKUP_FILE"

  echo "" | tee -a "$IP_LOOKUP_FILE"

  sleep 1  # prevents rate limiting
done < "$IPS_FILE"

echo "[+] Done. Results saved to $IP_LOOKUP_FILE"
