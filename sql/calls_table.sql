-- טבלת "קריאות פתוחות" ל-Supabase. הדבק והרץ ב-SQL Editor → Run.
create table if not exists calls (id text primary key, who text, kind text, loc text, status text, cdate text, ctime text, descr text, ts bigint);
grant all privileges on calls to anon, authenticated;
alter table calls enable row level security;
drop policy if exists p_all on calls;
create policy p_all on calls for all using (true) with check (true);
