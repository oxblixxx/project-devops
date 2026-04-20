#!/bin/bash
response=$(curl -s -X GET "http://your-api-endpoint.com")
echo "[$(date)] API response: $response"
