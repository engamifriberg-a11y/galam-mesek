-- אחסון סוגי המשטחים בענן (כדי שישותפו בין מכשירים). הרץ ב-SQL Editor → Run.
alter table pallets add column if not exists types jsonb;
