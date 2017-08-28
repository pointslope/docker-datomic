#!/usr/bin/env bash

: ${POSTGRES_URL:?"POSTGRES_URL must be set"}

type pgsql

psql ${POSTGRES_URL} -f bin/sql/postgres-db.sql -U postgres

DATABASE_URL=POSTGRES_URL/datomic

psql ${DATABASE_URL} -f bin/sql/postgres-table.sql -U postgres

psql ${DATABASE_URL} -f bin/sql/postgres-user.sql -U postgres
