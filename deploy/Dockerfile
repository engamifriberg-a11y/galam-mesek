# Optional: bake the static app into an nginx image (immutable deploys).
# Build from the repo root:  docker build -f deploy/Dockerfile -t galam-mesek-web .
FROM nginx:1.27-alpine
COPY deploy/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY index.html call.html sw.js manifest.webmanifest config.js /usr/share/nginx/html/
COPY icon-192.png icon-512.png icon-512-maskable.png /usr/share/nginx/html/
