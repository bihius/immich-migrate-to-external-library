#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="/opt/immich/upload/upload/" #default path for immich installed via proxmox helper scripts. 
DEST_DIR="/mnt/external_library/"
LIBRARY_NAME="External Library" # name of your external library in Immich
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

# Validate that the specified library exists
LIBRARY_ID=$(psql -At -c "SELECT id FROM libraries WHERE name = '$(sql_escape "$LIBRARY_NAME")';")
if [ -z "$LIBRARY_ID" ]; then
  echo "Error: Library '$LIBRARY_NAME' not found in database. Please create it in Immich first." >&2
  exit 1
fi

find "$SRC_DIR" -type f ! -name '.*' -print0 |
while IFS= read -r -d '' file; do
  orig_name=$(psql -At -c \
    "SELECT \"originalFileName\" FROM asset WHERE \"originalPath\" = '$(sql_escape "$file")';")

  [ -z "$orig_name" ] && continue

  new_path="$DEST_DIR$orig_name"

  if mv -n -- "$file" "$new_path"; then
    psql -v ON_ERROR_STOP=1 -c \
      "UPDATE asset SET
        \"originalPath\" = '$(sql_escape "$new_path")',
        \"isExternal\" = true,
        \"deviceId\" = 'Library Import',
        \"libraryId\" = '$(sql_escape "$LIBRARY_ID")'
      WHERE \"originalPath\" = '$(sql_escape "$file")';"
  fi
done
