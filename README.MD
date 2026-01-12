# Immich External Library Migration Script

## Overview
This script moves files from the Immich `upload` directory to a defined external library folder and updates their corresponding entries in the PostgreSQL database. 

## Features
- Moves non-hidden files from the upload directory into a permanent external library
- Updates PostgreSQL records to reflect the new file paths and marks assets as external library items
- Sets `isExternal`, `deviceId`, and `libraryId` fields to prevent Immich from re-importing files
- Prevents duplicate moves (`mv -n`)
- Fully configurable via environment variables at the top of the script
- Preservs original assets file name

## Requirements
- Bash shell
- `psql` (PostgreSQL client)
- Access to Immich's PostgreSQL database

## Configuration
Edit the variables at the top of the script:

```
SRC_DIR="/opt/immich/upload/upload/" #default path for immich installed with proxmox helper scripts
DEST_DIR="/mnt/external/"
LIBRARY_NAME="External Library" # name of your external library in Immich
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
3. Update their entries in the `asset` table in PostgreSQL:
   - Set `originalPath` to the new location
   - Set `isExternal` to true
   - Set `deviceId` to 'Library Import'
   - Set `libraryId` to match the specified external library


## Notes
- **Important**: Create your external library in Immich first and set `LIBRARY_NAME` to match its name
- Duplicate filenames across different folders will overwrite unless `mv -n` is used (kept by default)
- Use version control and backups before running on production data
- Adjust directories and database credentials as needed
- Script will move assets directly - no subfolders

