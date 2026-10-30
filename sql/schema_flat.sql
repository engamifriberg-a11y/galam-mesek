-- ניהול משק — טבלאות + הרשאות (גרסה שטוחה, בלי $$). הדבק והרץ ב-SQL Editor.
create table if not exists items (id text primary key, name text, unit text, stock integer default 0, cost numeric default 0);
create table if not exists departments (name text primary key);
create table if not exists distributors (name text primary key);
create table if not exists records (id text primary key, date text, dept text, item text, qty integer, "by" text, note text);
create table if not exists air_conditioners (num text primary key, loc text, model text, type text);
create table if not exists water_devices (serial text primary key, loc text, model text, note text);
create table if not exists pallets (id text primary key, prices jsonb, rows jsonb);
create table if not exists budgets (year integer primary key, amount numeric default 0);
create table if not exists doors (id text primary key, num text, maker text, supplier text, serial text, loc text, svc_phone text, contact text, mgr_phone text, email text, notes text);

grant usage on schema public to anon, authenticated;
grant all privileges on all tables in schema public to anon, authenticated;
grant all privileges on all sequences in schema public to anon, authenticated;

alter table items enable row level security;
alter table departments enable row level security;
alter table distributors enable row level security;
alter table records enable row level security;
alter table air_conditioners enable row level security;
alter table water_devices enable row level security;
alter table pallets enable row level security;
alter table budgets enable row level security;
alter table doors enable row level security;

drop policy if exists p_all on items;
create policy p_all on items for all using (true) with check (true);
drop policy if exists p_all on departments;
create policy p_all on departments for all using (true) with check (true);
drop policy if exists p_all on distributors;
create policy p_all on distributors for all using (true) with check (true);
drop policy if exists p_all on records;
create policy p_all on records for all using (true) with check (true);
drop policy if exists p_all on air_conditioners;
create policy p_all on air_conditioners for all using (true) with check (true);
drop policy if exists p_all on water_devices;
create policy p_all on water_devices for all using (true) with check (true);
drop policy if exists p_all on pallets;
create policy p_all on pallets for all using (true) with check (true);
drop policy if exists p_all on budgets;
create policy p_all on budgets for all using (true) with check (true);
drop policy if exists p_all on doors;
create policy p_all on doors for all using (true) with check (true);
