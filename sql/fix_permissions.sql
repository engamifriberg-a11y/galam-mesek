-- תיקון הרשאות anon על כל הטבלאות הציבוריות (פותר מצב "מתחבר" כשהטבלאות קיימות).
-- בטוח להרצה חוזרת, לא נוגע בנתונים.
grant usage on schema public to anon, authenticated;
grant all privileges on all tables in schema public to anon, authenticated;
grant all privileges on all sequences in schema public to anon, authenticated;

do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format('alter table public.%I enable row level security;', t);
    execute format('drop policy if exists p_all on public.%I;', t);
    execute format('create policy p_all on public.%I for all using (true) with check (true);', t);
  end loop;
end $$;
