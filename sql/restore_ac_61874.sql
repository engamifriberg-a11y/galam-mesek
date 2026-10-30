-- החזרת מזגן 61874 (חדר חשמל מתח גבוה שנאים ראשי) לטבלת Supabase. בטוח להרצה חוזרת.
insert into air_conditioners (num, loc, model, type)
values ('61874', 'חדר חשמל מתח גבוה שנאים ראשי', 'תדיראן JOY-42', 'מפוצל עילי')
on conflict (num) do update
  set loc = excluded.loc, model = excluded.model, type = excluded.type;
