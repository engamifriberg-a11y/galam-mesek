#!/bin/sh
# Runs once on first DB init (after 10-schema.sql). Sets the PostgREST login password.
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname galam <<SQL
alter role authenticator login password '${AUTHENTICATOR_PASSWORD}';
SQL
