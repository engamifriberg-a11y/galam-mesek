# Galam Mesek — self-hosting & operations

Self-host the management system (`index.html`) and the service-call form (`call.html`)
on Galam's own infrastructure. The frontend is static; all state lives in one central
PostgreSQL database shared by both apps.

See `ARCHITECTURE.he.md` for the component/dependency map, `MIGRATION-RUNBOOK.he.md`
for moving the live data, and `IT-HANDOFF.he.md` for what IT must decide/provide.

---

## Option A (recommended, shipped here): Postgres + PostgREST + nginx

Lightweight, easy to audit, no external services. Websocket realtime is replaced by
the app's built-in **20-second polling** (configurable via `window.GALAM_POLL_MS`), so
multi-user updates still appear quickly.

### 1. Requirements
- Linux host with **Docker** + **Docker Compose v2**.
- Outbound access **only during image pull** (`postgres:16-alpine`, `postgrest:v12.2.3`,
  `nginx:1.27-alpine`). Air-gapped? Pre-load the three images with `docker save`/`load`.
- A DNS name + TLS certificate (terminated at nginx, oauth2-proxy, or the org load balancer).

### 2. Install
```bash
cd deploy
cp .env.example .env            # set strong POSTGRES_PASSWORD and AUTHENTICATOR_PASSWORD
cp ../config.example.js ../config.js
# edit ../config.js:
#   window.SUPA_URL = "https://mesek.galam.co.il"   # the app's own public origin
#   window.SUPA_KEY = "galam-internal"              # any non-empty string (not used as a secret)
docker compose up -d
```
`schema.sql` loads automatically on first start (creates all 11 tables, the `web_anon`
read/write role, RLS, and sets the `authenticator` password). The app is served on
`http://<host>:${HTTP_PORT:-8080}`.

### 3. How the pieces connect
`index.html`/`call.html` use `supabase-js`, which calls `"<SUPA_URL>/rest/v1/<table>"`.
nginx serves the static app **and** reverse-proxies `/rest/v1/*` to PostgREST, so the
browser only ever talks to its own origin. PostgREST runs queries as `web_anon`.

### 4. Load the data
Fresh install seeds nothing. To migrate the live data from Supabase, follow
`MIGRATION-RUNBOOK.he.md` (uses `scripts/migrate-from-supabase.sh`).

---

## Option B (alternative): self-hosted Supabase

If you want **websocket realtime** and **built-in auth (incl. Azure/M365 provider)**
with zero app-code change, run the official Supabase Docker stack
(`github.com/supabase/supabase` → `docker/`). Then:
1. Load `deploy/schema.sql` into its database.
2. In `config.js` set `SUPA_URL` to your Supabase URL and `SUPA_KEY` to its **anon** key.
No frontend changes needed. Heavier footprint (~10 containers) but most faithful to today.

---

## HTTPS, org domain, and Microsoft 365 SSO

The app has **no login of its own**; put authentication in front of it:

- **TLS / domain:** terminate TLS at nginx, at `oauth2-proxy`, or at Galam's load
  balancer/reverse proxy; point the org DNS name at it.
- **M365 SSO (recommended):** uncomment the `oauth2-proxy` service in
  `docker-compose.yml`, register an app in **Entra ID**, and fill the `OAUTH2_*`
  values in `.env`. oauth2-proxy becomes the public entrypoint and only lets
  authenticated Galam users reach the app. (Alternative: Supabase Auth Azure provider
  if you chose Option B.) **Requires IT** — tenant ID, app registration, redirect URI.
- **No secrets in the browser:** `config.js` holds only the public URL + anon string.
  Never put a `service_role`/admin key or DB password in any browser-served file.

---

## Removing CDNs (fully offline frontend)

The app loads three libraries from public CDNs (see `ARCHITECTURE.he.md` §4). To remove them:
```bash
deploy/vendor/fetch-vendors.sh          # downloads supabase.js + xlsx.full.min.js
```
Then switch the tags in `index.html`/`call.html` to the local copies:
- `…/supabase-js@2.39.3/dist/umd/supabase.js`  → `deploy/vendor/supabase.js`
- `…/xlsx/0.18.5/xlsx.full.min.js`             → `deploy/vendor/xlsx.full.min.js`
- Google Fonts `<link>` → vendor `@fontsource/assistant` + `@fontsource/heebo`, **or**
  just delete the `<link>` (the CSS already falls back to a system-ui font stack).
`api.open-meteo.com` (weather) is cosmetic and degrades silently if blocked.

---

## Update
```bash
git pull                       # or copy the new files over
cd deploy && docker compose up -d --pull always
```
The static app is picked up on container restart (volume-mounted). Using the immutable
image instead? Rebuild: `docker build -f deploy/Dockerfile -t galam-mesek-web . && docker compose up -d`.

## Backup & restore
```bash
# nightly backup (cron): keeps a timestamped custom-format dump + sha256
DATABASE_URL="postgres://postgres:${POSTGRES_PASSWORD}@localhost:5432/galam" \
  deploy/scripts/backup.sh /var/backups/galam

# restore a specific dump (DROPS matching objects, then restores)
DATABASE_URL="postgres://postgres:...@localhost:5432/galam" \
  deploy/scripts/restore.sh /var/backups/galam/galam-YYYYMMDD-HHMMSS.dump

# row-count sanity check
DATABASE_URL="postgres://postgres:...@localhost:5432/galam" deploy/scripts/verify-integrity.sh
```
Suggested cron (02:00 daily, keep 30 days):
```
0 2 * * *  DATABASE_URL=postgres://postgres:***@localhost:5432/galam /opt/galam/deploy/scripts/backup.sh /var/backups/galam && find /var/backups/galam -name '*.dump' -mtime +30 -delete
```

> Tested on PostgreSQL 16: schema load (idempotent), ticket auto-numbering, survival
> across a DB restart, and a full backup → drop → restore round-trip with matching
> row counts. See `MIGRATION-RUNBOOK.he.md` §6 for what still needs testing in Galam's env.
