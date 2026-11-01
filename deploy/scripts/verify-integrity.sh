#!/usr/bin/env bash
# Galam Mesek — per-table row counts (run before and after a migration/restore and diff).
set -euo pipefail
: "${DATABASE_URL:?set DATABASE_URL}"
psql "$DATABASE_URL" -At -F',' -c "
  select 'items',count(*) from items
  union all select 'departments',count(*) from departments
  union all select 'distributors',count(*) from distributors
  union all select 'records',count(*) from records
  union all select 'air_conditioners',count(*) from air_conditioners
  union all select 'water_devices',count(*) from water_devices
  union all select 'pallets',count(*) from pallets
  union all select 'budgets',count(*) from budgets
  union all select 'doors',count(*) from doors
  union all select 'calls',count(*) from calls
  union all select 'dishwashers',count(*) from dishwashers
  order by 1;"
