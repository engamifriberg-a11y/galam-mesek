# הקמת מסד הנתונים (Supabase)

כל הקבצים כאן הם SQL להרצה ב-Supabase → SQL Editor.

## מה להריץ
- **`galam_supabase_FULL.sql`** — הקובץ הראשי. מריץ פעם אחת את הכול: יוצר את כל
  הטבלאות (items, records, departments, distributors, water_devices,
  air_conditioners, budgets, doors, pallets), ההרשאות, העדכונים החיים וכל
  הנתונים. בטוח להרצה חוזרת. אחרי שהוא רץ בהצלחה — הנקודה באתר עוברת ל-● חי.

## קבצים נוספים (כבר כלולים ב-FULL, שמורים כגיבוי)
- `galam_migration_v2.sql` — עמודת עלות לפריטים + טבלת תקציב.
- `galam_doors_table.sql` — טבלת דלתות מהירות.
- `galam_water_update.sql` — עדכון מצבת מכשירי המים ל-108.
- `restore_ac_61874.sql` — החזרת מזגן בודד (דוגמה).

## חיבור
האתר מתחבר ל-Supabase דרך `window.SUPA_URL` ו-`window.SUPA_KEY` שבתוך `index.html`
(מפתח anon ציבורי). RLS פתוח לכתיבה/קריאה ל-anon — ככה כל מי שנכנס או מתקין את
האפליקציה משתף את אותם נתונים.
