#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="/opt/immich/upload/upload/" #default path for immich installed via proxmox helper scripts. 
DEST_DIR="/mnt/external_library/"
PGDATABASE="immich"
PGUSER="immich"
PGHOST="localhost"
PGPORT="5432"
PGPASSWORD="password"

sql_escape() {
  printf "%s" "$1" | sed "s/'/''/g"
}

export LC_ALL=C
export PGDATABASE PGUSER PGHOST PGPORT PGPASSWORD

find "$SRC_DIR" -type f ! -name '.*' -print0 |
while IFS= read -r -d '' file; do
  base="$(basename "$file")"
  base_sql="$(sql_escape "$base")"
  if mv -n -- "$file" "$DEST_DIR"; then
    psql -v ON_ERROR_STOP=1 -c \
      "DELETE FROM asset WHERE \"originalPath\" = '$(sql_escape "$file")';"
  fi
done
