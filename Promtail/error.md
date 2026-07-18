# Error Documentation

## Table of Contents
- [TIMESTAMP TOO NEW Error](#timestamp-too-new-error)
- [Another Error](#another-error)

---

## TIMESTAMP TOO NEW Error {#promtail-timestamp-too-new-error}

### Error

```sh
level=error ts=2026-07-18T20:39:02.731478747Z caller=client.go:430 component=client host=172.28.30.17:3100 msg="final error sending batch" status=400 tenant= error="server returned HTTP status 400 Bad Request (400): entry for stream '{...}' has timestamp too new: 2026-07-19T02:09:01Z"
```

### Root Cause
The application writes logs in a timezone ahead of the server (Promtail/Loki) timezone. In this case, the app uses Asia/Kolkata (UTC+5:30) while the server runs on UTC. Promtail parses the log timestamp as-is and rejects it because it appears to be in the future relative to the server clock.

### Fix
Add the location field to the timestamp stage in your promtail-config.yaml to tell Promtail the source timezone:

```yaml
scrape_configs:
  - job_name: hello_world
    pipeline_stages:
      - timestamp:
          source: timestamp
          format: '2006-01-02 15:04:05'
          location: "Asia/Kolkata"  # <-- App's timezone
```

### Key Points
1. location accepts any IANA timezone string (e.g., America/New_York, Europe/Berlin, Asia/Tokyo)
2. Without location, Promtail assumes the timestamp is in the server's local timezone
3. Loki rejects entries with timestamps newer than the current server time (with a small grace period)
