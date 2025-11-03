#!/bin/bash

# Database Backup Script

set -e

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="${HOME}/backups"
mkdir -p $BACKUP_DIR

echo "Creating database backup..."

docker-compose exec -T db pg_dump -U postgres predico > $BACKUP_DIR/backup_$DATE.sql

# Compress backup
gzip $BACKUP_DIR/backup_$DATE.sql

echo "Backup completed: $BACKUP_DIR/backup_$DATE.sql.gz"

# Keep only last 7 days of backups
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +7 -delete

echo "Old backups (older than 7 days) cleaned up."

