#!/usr/bin/env bash
# Galam Mesek — one-time data migration from the current Supabase project to the
# new self-hosted database. Schema must already exist on the target (deploy/schema.sql).
#
#   SOURCE_DB_URL  = Supabase direct Postgres connection string
#                    (Supabase Dashboard > Project Settings > Database > Connection string,
#                     role 'postgres'. Use the direct 5432 string, not the pooler, for pg_dump.)
#   TARGET_DB_URL  = new self-hosted DB (postgres://postgres:...@host:5432/galam)
#
# Usage: SOURCE_DB_URL=... TARGET_DB_URL=... ./migrate-from-supabase.sh
set -euo pipefail
: "${SOURCE_DB_URL:?set SOURCE_DB_URL}"; : "${TARGET_DB_URL:?set TARGET_DB_URL}"
TABLES="items departments distributors records air_conditioners water_devices pallets budgets doors calls dishwashers"
WORK=$(mktemp -d); DUMP="$WORK/data.dump"
echo "== dumping DATA ONLY from Supabase (public schema, app tables) =="
pg_dump --data-only --no-owner --no-privileges --format=custom \
  $(for t in $TABLES; do echo --table=public.$t; done) \
  "$SOURCE_DB_URL" -f "$DUMP"
echo "== source row counts =="; DATABASE_URL="$SOURCE_DB_URL" bash "$(dirname "$0")/verify-integrity.sh" | tee "$WORK/src.csv"
echo "== loading into target (data only; append) =="
pg_restore --data-only --no-owner --no-privileges --disable-triggers --dbname "$TARGET_DB_URL" "$DUMP"
# realign the calls ticket sequence after import
psql "$TARGET_DB_URL" -c "select setval('calls_num_seq', coalesce((select max(num) from calls),1));" >/dev/null || true
echo "== target row counts =="; DATABASE_URL="$TARGET_DB_URL" bash "$(dirname "$0")/verify-integrity.sh" | tee "$WORK/dst.csv"
echo "== integrity diff (empty = identical) =="
if diff <(cut -d',' -f1,2 "$WORK/src.csv") <(cut -d',' -f1,2 "$WORK/dst.csv"); then
  echo "OK — row counts match."
else
  echo "WARNING — counts differ, investigate before cutover."; exit 2
fi
