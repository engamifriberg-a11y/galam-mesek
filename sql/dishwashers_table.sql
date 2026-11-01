-- טבלת מדיחי כלים ל-Supabase. הדבק והרץ ב-SQL Editor → Run.
create table if not exists dishwashers (id text primary key, loc text, dept text);
grant all privileges on dishwashers to anon, authenticated;
alter table dishwashers enable row level security;
drop policy if exists p_all on dishwashers;
create policy p_all on dishwashers for all using (true) with check (true);
