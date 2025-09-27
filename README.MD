# Immich External Library Migration Script

## Overview
This script moves files from the Immich `upload` directory to a defined external library folder and removes their corresponding entries from the PostgreSQL database. It ensures all assets remain accessible in the external path while keeping Immich's database clean.

## Features
- Moves non-hidden files from the upload directory into a permanent external library
- Updates PostgreSQL records to reflect the new file paths  
- Prevents duplicate moves (`mv -n`)
- Fully configurable via environment variables at the top of the script

## Requirements
- Bash shell
- `psql` (PostgreSQL client)
- Access to Immich's PostgreSQL database with proper credentials

## Configuration
Edit the variables at the top of the script:

```
SRC_DIR="/opt/immich/upload/upload/"
DEST_DIR="/srv/gallery/Zosia/"
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
3. Delete their entries from the `asset` table in PostgreSQL

## Important Note
After running the script, the moved assets will not immediately appear in Immich. This is because the script does not trigger an external library scan. This was left unimplemented because:
- Immich automatically scans external libraries daily at midnight
- You can enable library watching for near real-time updates

## Notes
- Duplicate filenames across different folders will overwrite unless `mv -n` is used (kept by default)
- Use version control and backups before running on production data
- Adjust directories and database credentials as needed

