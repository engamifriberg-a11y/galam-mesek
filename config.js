/* Galam Mesek — runtime configuration served to the browser.
 * Provided at DEPLOY time. Contains NO server/admin secrets.
 * SUPA_KEY is the PUBLIC anon key only — access is governed by the DB policies
 * and (in the Galam deployment) by the SSO reverse proxy in front of the app.
 * To point the apps at a different backend, change the two values below. */
window.SUPA_URL = "https://zrmjfxztaeuuvdqhwdzm.supabase.co";
window.SUPA_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpybWpmeHp0YWV1dXZkcWh3ZHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5NDA3MTksImV4cCI6MjEwODUxNjcxOX0.ENmZvUV66S7AH7bZF3EEXzYzgbgGewfMgSJPiKQMMMY";
/* Optional: polling interval (ms) for backends without websocket realtime. */
/* window.GALAM_POLL_MS = 20000; */
