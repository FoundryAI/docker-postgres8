#!/bin/bash
set -e

# If we're starting the DB
if [ "$1" = 'postgres' ]; then
  mkdir -p "$PGDATA"
	chmod 700 "$PGDATA"
	chown -R postgres "$PGDATA"

  # Run initialization if PG_VERSION is not set
  if [ ! -s "$PGDATA/PG_VERSION" ]; then
    eval "gosu postgres initdb"

    cp -R /config/* "$PGDATA"

    gosu postgres pg_ctl -D "$PGDATA" -w start

    if [ "$POSTGRES_DATABASE" != 'postgres' ]; then
      gosu postgres createdb $POSTGRES_DATABASE
    fi

    if [ "$POSTGRES_USER" = 'postgres' ]; then
    	op='ALTER'
    else
    	op='CREATE'
    fi

    gosu postgres psql \
      --username postgres \
      -c "$op USER "$POSTGRES_USER" WITH PASSWORD '$POSTGRES_PASSWORD';"

    # REDSHIFT:START
    gosu postgres psql \
      --username postgres \
      -c "CREATE USER rdsdb;"
    # REDSHIFT:END

    gosu postgres pg_ctl -D "$PGDATA" -w stop
  fi

  exec gosu postgres "$@"
fi

exec "$@"
