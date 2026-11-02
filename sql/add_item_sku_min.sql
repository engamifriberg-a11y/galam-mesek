-- מק"ט ומלאי מינימום לפריטים. הרץ ב-Supabase → SQL Editor → Run.
alter table items add column if not exists sku text;
alter table items add column if not exists min_stock integer default 0;
notify pgrst, 'reload schema';
