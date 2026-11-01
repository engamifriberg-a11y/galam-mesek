#!/usr/bin/env bash
# Download the 3 third-party browser libs so the app needs NO external CDN.
# Run on a machine WITH internet, then commit the vendor/ files and switch the
# <script>/<link> tags to the local paths (see deploy/README.md "Removing CDNs").
set -euo pipefail
cd "$(dirname "$0")"
curl -fsSL https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.39.3/dist/umd/supabase.js  -o supabase.js
curl -fsSL https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js             -o xlsx.full.min.js
# Hebrew-capable fonts (Google Fonts, OFL). Vendor the CSS + woff2, or replace the
# Google Fonts <link> in index.html with a system-font stack (already the CSS fallback).
echo "Fetched supabase.js and xlsx.full.min.js into $(pwd)."
echo "Fonts: either vendor @fontsource/assistant + @fontsource/heebo, or drop the"
echo "Google Fonts <link> (the CSS already falls back to system-ui)."
