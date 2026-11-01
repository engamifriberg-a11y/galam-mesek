-- ==========================================================================
--  Galam Mesek — consolidated database schema (PostgreSQL)
--  Works on: self-hosted Supabase  AND  plain Postgres + PostgREST.
--  Idempotent: safe to run more than once.
--  Run:  psql "$DATABASE_URL" -f deploy/schema.sql
-- ==========================================================================

-- ---- tables -------------------------------------------------------------
create table if not exists items (
  id text primary key, name text, unit text,
  stock integer default 0, cost numeric default 0);

create table if not exists departments  (name text primary key);
create table if not exists distributors (name text primary key);

create table if not exists records (
  id text primary key, date text, dept text, item text,
  qty integer, "by" text, note text);

create table if not exists air_conditioners (
  num text primary key, loc text, model text, type text);

create table if not exists water_devices (
  serial text primary key, loc text, model text, note text);

create table if not exists pallets (
  id text primary key, prices jsonb, rows jsonb, types jsonb);

create table if not exists budgets (
  year integer primary key, amount numeric default 0);

create table if not exists doors (
  id text primary key, num text, maker text, supplier text, serial text,
  loc text, svc_phone text, contact text, mgr_phone text, email text, notes text);

-- calls.num is an auto-incrementing service-ticket number
create table if not exists calls (
  id text primary key, who text, kind text, loc text, status text,
  cdate text, ctime text, descr text, ts bigint, num serial);

create table if not exists dishwashers (
  id text primary key, loc text, dept text);

-- ---- roles (plain Postgres + PostgREST path) ----------------------------
-- On Supabase these already exist; the exception handler makes this a no-op there.
do $$
begin
  if not exists (select 1 from pg_roles where rolname='web_anon') then
    create role web_anon nologin;
  end if;
exception when others then null;
end $$;

do $$
begin
  if not exists (select 1 from pg_roles where rolname='authenticator') then
    -- password is overridden by the deployment (see .env); placeholder only.
    create role authenticator noinherit login password 'change-me';
  end if;
  grant web_anon to authenticator;
exception when others then null;
end $$;

-- ---- privileges ---------------------------------------------------------
grant usage on schema public to web_anon;
grant all privileges on all tables   in schema public to web_anon;
grant all privileges on all sequences in schema public to web_anon;
alter default privileges in schema public grant all on tables    to web_anon;
alter default privileges in schema public grant all on sequences to web_anon;

-- Supabase roles, when present (ignored on plain Postgres).
do $$
begin
  grant usage on schema public to anon, authenticated;
  grant all privileges on all tables    in schema public to anon, authenticated;
  grant all privileges on all sequences in schema public to anon, authenticated;
  alter default privileges in schema public grant all on tables    to anon, authenticated;
  alter default privileges in schema public grant all on sequences to anon, authenticated;
exception when others then null;
end $$;

-- ---- row level security -------------------------------------------------
-- Permissive policy for every role (TO public). Real access control is done
-- by the SSO reverse proxy in front of the app (see deploy/README.md).
do $$
declare t text;
begin
  foreach t in array array['items','departments','distributors','records',
    'air_conditioners','water_devices','pallets','budgets','doors','calls','dishwashers']
  loop
    execute format('alter table %I enable row level security;', t);
    execute format('drop policy if exists p_all on %I;', t);
    execute format('create policy p_all on %I for all using (true) with check (true);', t);
  end loop;
end $$;

-- ---- realtime (Supabase only; ignored elsewhere) ------------------------
do $$
declare t text;
begin
  foreach t in array array['items','departments','distributors','records',
    'air_conditioners','water_devices','pallets','budgets','doors','calls','dishwashers']
  loop
    begin execute format('alter publication supabase_realtime add table %I;', t);
    exception when others then null; end;
  end loop;
exception when others then null;
end $$;

-- PostgREST schema-cache reload (ignored if PostgREST not listening yet)
notify pgrst, 'reload schema';
