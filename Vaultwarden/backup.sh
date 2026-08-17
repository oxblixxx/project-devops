#!/bin/bash
set -euo pipefail

# ===== CONFIG =====
VAULTWARDEN_DIR="/var/www/html/vaultwarden"        # path to vaultwarden data
BACKUP_DIR="/var/backups/vaultwarden"
BUCKET="xxxxxx"
B2_PATH="vaultwarden"
DATE="$(date +%F)"
ARCHIVE="vaultwarden-backup-${DATE}.tar.gz"

# ===== ENSURE DIR =====
mkdir -p "$BACKUP_DIR"

# ===== STOP VAULTWARDEN (SAFE SNAPSHOT) =====
docker stop vaultwarden >/dev/null

# ===== CREATE ARCHIVE =====
tar -czf "${BACKUP_DIR}/${ARCHIVE}" -C "$VAULTWARDEN_DIR" .

# ===== START VAULTWARDEN =====
docker start vaultwarden >/dev/null

# ===== UPLOAD TO B2 =====
b2 file upload \
  --no-progress \
  "$BUCKET" \
  "${BACKUP_DIR}/${ARCHIVE}" \
  "${B2_PATH}/${ARCHIVE}"

# ===== OPTIONAL: LOCAL ROTATION (KEEP 7 DAYS) =====
find "$BACKUP_DIR" -type f -name "vaultwarden-backup-*.tar.gz" -mtime +7 -delete
