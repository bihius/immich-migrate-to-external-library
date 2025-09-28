# Immich External Library Migration Script

## Overview
This script moves files from the Immich `upload` directory to a defined external library folder and updates their corresponding entries in the PostgreSQL database. 

## Features
- Moves non-hidden files from the upload directory into a permanent external library
- Updates PostgreSQL records to reflect the new file paths  
- Prevents duplicate moves (`mv -n`)
- Fully configurable via environment variables at the top of the script

## Requirements
- Bash shell
- `psql` (PostgreSQL client)
- Access to Immich's PostgreSQL database

## Configuration
Edit the variables at the top of the script:

```
SRC_DIR="/opt/immich/upload/upload/" #default path for immich installed with proxmox helper scripts
DEST_DIR="/mnt/external/"
PGDATABASE="immich"
PGUSER="immich"
PGHOST="localhost"
PGPORT="5432"
PGPASSWORD="your_password"
```

For better security, consider using a `~/.pgpass` file instead of hardcoding the password.

## Usage
Make the script executable and run it:

```
chmod +x migrate.sh
./migrate.sh
```

The script will:
1. Find all non-hidden files under `SRC_DIR`
2. Move them to `DEST_DIR`
3. Update their entries in the `asset` table in PostgreSQL


## Notes
- Duplicate filenames across different folders will overwrite unless `mv -n` is used (kept by default)
- Use version control and backups before running on production data
- Adjust directories and database credentials as needed
- Script will move assets directly - no subfolders

