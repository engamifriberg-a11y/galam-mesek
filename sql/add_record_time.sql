-- שעת לקיחת/מסירת ציוד לרשומות החלוקה. הרץ ב-Supabase → SQL Editor → Run.
alter table records add column if not exists time text;
notify pgrst, 'reload schema';
