#!/usr/bin/env bash
# Galam Mesek — database backup. Usage: DATABASE_URL=postgres://... ./backup.sh [outdir]
set -euo pipefail
: "${DATABASE_URL:?set DATABASE_URL (postgres://user:pass@host:5432/galam)}"
OUT="${1:-./backups}"; mkdir -p "$OUT"
TS=$(date +%Y%m%d-%H%M%S)
FILE="$OUT/galam-$TS.dump"
pg_dump --format=custom --no-owner --no-privileges "$DATABASE_URL" -f "$FILE"
sha256sum "$FILE" > "$FILE.sha256"
echo "backup: $FILE ($(du -h "$FILE" | cut -f1))"
echo "sha256: $(cut -d' ' -f1 "$FILE.sha256")"
