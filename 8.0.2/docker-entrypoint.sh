#!/bin/bash
set -e

/usr/local/pgsql/bin/pg_ctl -D ./usr/local/pgsql/data -w start

/usr/local/pgsql/bin/createdb $POSTGRES_DATABASE || true

if [ "$POSTGRES_USER" = 'postgres' ]; then
	op='ALTER'
else
	op='CREATE'
fi

/usr/local/pgsql/bin/psql --username postgres <<-EOSQL
	$op USER "$POSTGRES_USER" WITH PASSWORD '$POSTGRES_PASSWORD' ;
EOSQL

/usr/local/pgsql/bin/pg_ctl -D ./usr/local/pgsql/data stop

exec "$@"
