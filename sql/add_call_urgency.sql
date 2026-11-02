-- דחיפות לקריאות שירות (1=דחוף מאוד … 5=לא דחוף). הרץ ב-Supabase → SQL Editor → Run.
alter table calls add column if not exists urgency smallint default 3;
notify pgrst, 'reload schema';
