#!/usr/bin/env bash
# Galam Mesek — restore a backup into DATABASE_URL (DROPS matching objects first).
# Usage: DATABASE_URL=postgres://... ./restore.sh path/to/galam-YYYYMMDD-HHMMSS.dump
set -euo pipefail
: "${DATABASE_URL:?set DATABASE_URL}"; FILE="${1:?pass the .dump file}"
if [ -f "$FILE.sha256" ]; then (cd "$(dirname "$FILE")" && sha256sum -c "$(basename "$FILE").sha256"); fi
pg_restore --clean --if-exists --no-owner --no-privileges --dbname "$DATABASE_URL" "$FILE"
echo "restored from $FILE"
