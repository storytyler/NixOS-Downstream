{ pkgs, ... }:
pkgs.writeShellScriptBin "hindsight-backup" ''
  #!/bin/bash
  set -euo pipefail

  BACKUP_DIR="/var/backups/hindsight"
  TIMESTAMP=$(date +%Y%m%d)
  BACKUP_FILE="$BACKUP_DIR/hindsight_$TIMESTAMP.zip"
  LOG_FILE="/var/log/hindsight-backup.log"

  # Create backup directory and log file
  sudo mkdir -p "$BACKUP_DIR"
  sudo touch "$LOG_FILE"

  log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $*" | sudo tee -a "$LOG_FILE"
  }

  log "Starting Hindsight backup"

  # Check if Hindsight container is running
  if ! docker ps --format '{{.Names}}' | grep -q '^hindsight$'; then
    log "ERROR: Hindsight container not running"
    exit 1
  fi

  # Create backup inside Docker container
  log "Creating backup in container"
  if ! docker exec hindsight hindsight-admin backup "/tmp/hindsight_backup.zip"; then
    log "ERROR: Backup command failed"
    exit 1
  fi

  # Copy backup to host
  log "Copying backup to host: $BACKUP_FILE"
  if ! sudo docker cp hindsight:/tmp/hindsight_backup.zip "$BACKUP_FILE"; then
    log "ERROR: Failed to copy backup"
    exit 1
  fi

  # Cleanup container temp file
  docker exec hindsight rm -f /tmp/hindsight_backup.zip || true

  # Rotate: keep last 7 daily backups
  log "Rotating old backups (keeping last 7 days)"
  DELETED=$(
    sudo find "$BACKUP_DIR" -name "hindsight_*.zip" -mtime +7 -print0 |
    xargs -0 sudo rm -v 2>/dev/null | wc -l
  )

  # Count current backups
  COUNT=$(sudo find "$BACKUP_DIR" -name "hindsight_*.zip" -type f | wc -l)

  log "Backup complete: $BACKUP_FILE"
  log "Deleted $DELETED old backups"
  log "Total backups kept: $COUNT"
''
