-- הוספת מספר קריאה רץ (אוטומטי) לטבלת הקריאות. הרץ ב-SQL Editor → Run.
alter table calls add column if not exists num serial;
