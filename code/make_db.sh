#! /usr/bin/env bash

sleep 3
dropdb metabase_state --if-exists
createdb metabase_state
