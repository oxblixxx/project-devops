#!/bin/bash

# ═══════════════════════════════════════════
#            CONFIGURATION
# ═══════════════════════════════════════════
EMAIL="xxxxxxxx"
BACKUP_DIR="/var/backups/databases"
GDRIVE_FOLDER="xxxxx:xxxxx"
GDRIVE_VIEW_URL="https://drive.google.com/drive/u/2/folders/xxxxxxxxxxxxxxxxx"
RETENTION_DAYS=2
USE_DRIVE=true        # Strict Drive upload mode
DATE=$(date +%Y-%m-%d_%H-%M)
MYSQL_LOGIN_PATH="mysqldump"
PG_USER="backupsvc"
HOSTNAME=$(hostname)
DATE_SUBDIR="$BACKUP_DIR/$DATE"
MYSQL_SUBDIR="$DATE_SUBDIR/mysql"
PG_SUBDIR="$DATE_SUBDIR/postgresql"

# ═══════════════════════════════════════════

set -euo pipefail  # Strict error handling

mkdir -p "$BACKUP_DIR"
mkdir -p "$MYSQL_SUBDIR" "$PG_SUBDIR"
SUCCEEDED=()
FAILED=()
ATTACHMENTS=()
DRIVE_UPLOADS=()
TOTAL_BYTES=0
log() { echo "[$(date +%T)] $1"; }
log "════════ DB BACKUP STARTED ════════"

# ───────────────────────────────────────────
#  MYSQL BACKUPS
# ───────────────────────────────────────────
log "Starting MySQL backups..."

if command -v mysqldump &>/dev/null; then
  MYSQL_DBS=$(mysql --login-path="$MYSQL_LOGIN_PATH" -e "SHOW DATABASES;" 2>/dev/null \
    | grep -Ev "^(Database|information_schema|performance_schema|sys)$")

  for DB in $MYSQL_DBS; do
    FILE="$MYSQL_SUBDIR/mysql_${DB}_${DATE}.sql.gz"
    mysqldump --login-path="$MYSQL_LOGIN_PATH" \
      --single-transaction \
      --quick \
      --routines \
      --triggers \
      --no-tablespaces \
      "$DB" 2>/dev/null | gzip > "$FILE"

    if [[ ${PIPESTATUS[0]} -eq 0 && -s "$FILE" ]]; then
      SIZE=$(du -sh "$FILE" | cut -f1)
      SUCCEEDED+=("MySQL › $DB ($SIZE)")
      ATTACHMENTS+=("$FILE")
      log "  ✓ MySQL: $DB ($SIZE)"
    else
      FAILED+=("MySQL › $DB")
      rm -f "$FILE"
      log "  ✗ MySQL: $DB FAILED"
    fi
  done
else
  log "  MySQL not found, skipping."
fi


# ───────────────────────────────────────────
#  POSTGRESQL BACKUPS
# ────────────────
log "Starting PostgreSQL backups..."

if command -v pg_dump &>/dev/null; then

  # Get list of databases (FIXED: specify database)
  PG_DBS=$(sudo -u "$PG_USER" psql -d postgres -t -A \
    -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';")

  log "Databases found:"
  echo "$PG_DBS"

  # Safe loop
  while IFS= read -r DB; do
    [ -z "$DB" ] && continue

    FILE="$PG_SUBDIR/pg_${DB}_${DATE}.dump.gz"

    # Dump (FIXED: specify database)
    if sudo -u "$PG_USER" pg_dump -d "$DB" -Fc | gzip > "$FILE"; then

      if [[ -s "$FILE" ]]; then
        SIZE=$(du -sh "$FILE" | cut -f1)
        BYTES=$(stat -c%s "$FILE")
        TOTAL_BYTES=$((TOTAL_BYTES + BYTES))

        SUCCEEDED+=("PostgreSQL › $DB ($SIZE)")
        ATTACHMENTS+=("$FILE")

        log "  ✓ PostgreSQL: $DB ($SIZE)"
      else
        FAILED+=("PostgreSQL › $DB (empty file)")
        rm -f "$FILE"
        log "  ✗ PostgreSQL: $DB EMPTY"
      fi

    else
      FAILED+=("PostgreSQL › $DB")
      rm -f "$FILE"
      log "  ✗ PostgreSQL: $DB FAILED"
    fi

  done <<< "$PG_DBS"

else
  log "PostgreSQL not found, skipping."
fi
echo "POSTGRESQL DUMP DONE SUCCESFULLY"

# ───────────────────────────────────────────
#  UPLOAD TO GOOGLE DRIVE
# ───────────────────────────────────────────
DRIVE_DATE_FOLDER="$GDRIVE_FOLDER/$DATE"
log "Starting Google Drive upload..."

if [ "$USE_DRIVE" = true ]; then
    # Create folder, capture error instead of dying
    if ! rclone mkdir "$DRIVE_DATE_FOLDER" 2>/dev/null; then
        log "  ✗ Failed to create Drive folder: $DRIVE_DATE_FOLDER"
        FAILED+=("Drive › mkdir $DRIVE_DATE_FOLDER")
    fi

    for FILE in "${ATTACHMENTS[@]}"; do
        FNAME=$(basename "$FILE")
        FILESIZE=$(du -sh "$FILE" | cut -f1)

        log "  Uploading: $FNAME ($FILESIZE)..."

        # Use larger chunk size for big files, timeout, and retry
        # This was used when there was a DB size of 6GB, which failed to upload after retries.
        if rclone copy "$FILE" "$DRIVE_DATE_FOLDER/" \
                --drive-chunk-size 256M \
                --transfers 1 \
                --checkers 2 \
                --timeout 10m \
                --retries 3 \
                --low-level-retries 10 \
                --progress 2>/tmp/rclone_error.log; then

            DRIVE_UPLOADS+=("$FNAME")
            log "  ↑ Uploaded: $FNAME"
        else
            RCLONE_ERR=$(cat /tmp/rclone_error.log 2>/dev/null | tail -n 3)
            FAILED+=("Drive Upload › $FNAME ($FILESIZE)")
            log "  ✗ Drive upload failed: $FNAME"
            [ -n "$RCLONE_ERR" ] && log "    Error: $RCLONE_ERR"
        fi
    done
else
    log "  Google Drive upload disabled."
fi

# ───────────────────────────────────────────
#  CLEANUP OLD BACKUPS
# ───────────────────────────────────────────
log "Cleaning backups older than $RETENTION_DAYS days..."

# Only cleanup Drive if we successfully connected
if [ "$USE_DRIVE" = true ] && [ ${#DRIVE_UPLOADS[@]} -gt 0 ]; then
    rclone delete "$GDRIVE_FOLDER" --min-age ${RETENTION_DAYS}d --drive-use-trash=false 2>/dev/null || true

    rclone lsf "$GDRIVE_FOLDER" --dirs-only 2>/dev/null | \
    grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}/?$' | \
    while read -r FOLDER; do
        FOLDER=${FOLDER%/}
        FOLDER_DATE=$(echo "$FOLDER" | cut -d_ -f1)

        if date -d "$FOLDER_DATE" >/dev/null 2>&1; then
            if [ "$(date -d "$FOLDER_DATE" +%s)" -lt "$(date -d "$RETENTION_DAYS days ago" +%s)" ]; then
                rclone purge "$GDRIVE_FOLDER/$FOLDER" --drive-use-trash=false 2>/dev/null || true
            else
                log "  ✅ KEEP: $FOLDER"
            fi
        else
            log "  ⚠️ INVALID DATE: $FOLDER"
        fi
    done
fi

# Local cleanup
[ -z "$BACKUP_DIR" ] && log "BACKUP_DIR is not set!" && exit 1
log "Cleaning local backups in: $BACKUP_DIR"
find "$BACKUP_DIR" -type f -name "*.gz" -mtime +3 -delete
find "$BACKUP_DIR" -type d -empty -delete

# ───────────────────────────────────────────
#  CALCULATE TOTAL SIZE
# ───────────────────────────────────────────
TOTAL_BYTES=0
for FILE in "${ATTACHMENTS[@]}"; do
    if [ -f "$FILE" ]; then
        BYTES=$(stat -c%s "$FILE" 2>/dev/null || echo 0)
        TOTAL_BYTES=$((TOTAL_BYTES + BYTES))
    fi
done
TOTAL_MB=$(( (TOTAL_BYTES + 512*1024 - 1) / (1024*1024) ))
log "TOTAL: ${TOTAL_BYTES} bytes = ${TOTAL_MB}MB"

# ───────────────────────────────────────────
#  SEND NOTIFICATION
# ───────────────────────────────────────────
log "Sending notification..."

SUBJECT="DB Backup $HOSTNAME $(date '+%d/%b') - ${#SUCCEEDED[@]} OK"
[ ${#FAILED[@]} -gt 0 ] && SUBJECT="${SUBJECT} | ${#FAILED[@]} Failed"

cat > /tmp/backup_report.txt << EOF

═══════════════════════════════════════════════
      DATABASE BACKUP REPORT - $HOSTNAME
═══════════════════════════════════════════════
Date: $(date '+%d %B %Y %H:%M:%S')
Total: ${#SUCCEEDED[@]} succeeded | ${#FAILED[@]} failed
Size: ${TOTAL_MB}MB | Drive: $GDRIVE_VIEW_URL

✅ SUCCEEDED:
EOF

printf '  %s\n' "${SUCCEEDED[@]}" >> /tmp/backup_report.txt

if [ ${#FAILED[@]} -gt 0 ]; then
    cat >> /tmp/backup_report.txt << EOF

❌ FAILED:
EOF
    printf '  %s\n' "${FAILED[@]}" >> /tmp/backup_report.txt
fi

# Show Drive upload summary if applicable
if [ "$USE_DRIVE" = true ]; then
    cat >> /tmp/backup_report.txt << EOF

☁️  DRIVE UPLOADS: ${#DRIVE_UPLOADS[@]}/${#ATTACHMENTS[@]} files uploaded
EOF
fi

cat >> /tmp/backup_report.txt << EOF

═══════════════════════════════════════════════
Local: $BACKUP_DIR/$DATE/
Drive: $GDRIVE_VIEW_URL
Retention: $RETENTION_DAYS days
EOF

# Send email
if mutt -s "$SUBJECT" -- "$EMAIL" < /tmp/backup_report.txt 2>/dev/null; then
    log "✅ Email sent to $EMAIL (${#SUCCEEDED[@]} succeeded, ${#FAILED[@]} failed)"
else
    log "❌ Email FAILED - check mutt config!"
    # Don't exit 1 here — we want cleanup to run
fi

rm -f /tmp/backup_report.txt /tmp/rclone_error.log /tmp/backup-debug.log
log "════════ BACKUP COMPLETE ════════"
