#! /usr/bin/env bash

sleep 3
# Drop the existing database (if it exists)
dropdb -U $PGUSER -h $PGHOST -p $PGPORT metabase_state

# Create a new, empty database
createdb -U $PGUSER -h $PGHOST -p $PGPORT metabase_state

# Restore the backup into the new database
psql -U $PGUSER -h $PGHOST -p $PGPORT -d metabase_state -f /backup/metabase_db_backup.sql
