#! /usr/bin/env bash

sleep 3
rm -f /backup/metabase_db_backup.sql || 1
pg_dump -F p -b -v -d metabase_state  -f /backup/metabase_db_backup.sql 
