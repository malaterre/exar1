#!/bin/sh -e
set -x

in="$1"
sqlite3 "$in" .schema > schema.sql
sqlite3 "$in" .dump > dump.sql
