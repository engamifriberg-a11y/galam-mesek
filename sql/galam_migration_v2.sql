-- ========= עדכון מסד נתונים: עלות פריטים + תקציב =========
-- להריץ פעם אחת ב-SQL Editor של Supabase (בנוסף לקובץ ההקמה הקיים)

-- 1) עמודת עלות (₪ ליחידה) לכל פריט במלאי
alter table items add column if not exists cost numeric default 0;

-- 2) טבלת תקציב שנתי
create table if not exists budgets (year integer primary key, amount numeric default 0);
alter table budgets enable row level security;
drop policy if exists p_all on budgets;
create policy p_all on budgets for all using (true) with check (true);
grant all on budgets to anon, authenticated;

-- 3) עדכונים חיים (realtime) לטבלת התקציב
do $$ begin
  begin
    alter publication supabase_realtime add table budgets;
  exception when duplicate_object then null;
  end;
end $$;
