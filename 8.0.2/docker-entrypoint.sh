#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
  set -- postmaster "$@"
fi

# If we're starting the DB
if [ "$1" = 'postmaster' ]; then
  mkdir -p "$PGDATA"
  chmod 700 "$PGDATA"
  chown -R postgres "$PGDATA"

  # Run initialization if PG_VERSION is not set
  if [ ! -s "$PGDATA/PG_VERSION" ]; then
    eval "gosu postgres initdb"

    cp -R /config/* "$PGDATA"

    gosu postgres pg_ctl -D "$PGDATA" -w start

    if ! gosu postgres psql -lqt | cut -d \| -f 1 | grep -qw postgres; then
      gosu postgres createdb
    fi

    if ! gosu postgres psql -lqt | cut -d \| -f 1 | grep -qw "$POSTGRES_USER"; then
      gosu postgres createdb "$POSTGRES_USER"
    fi

    if ! gosu postgres psql -lqt | cut -d \| -f 1 | grep -qw "$POSTGRES_DATABASE"; then
      gosu postgres createdb "$POSTGRES_DATABASE"
    fi

    gosu postgres psql -lqt

    if [ "$POSTGRES_USER" = 'postgres' ]; then
      op='ALTER'
    else
      op='CREATE'
    fi

    gosu postgres psql \
      -c "$op USER "$POSTGRES_USER" WITH PASSWORD '$POSTGRES_PASSWORD';"

    psql=( psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DATABASE" )

    for f in /docker-entrypoint-initdb.d/*; do
      case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.sql)    echo "$0: running $f"; "${psql[@]}" -f "$f"; echo ;;
        *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
        *)        echo "$0: ignoring $f" ;;
      esac
      echo
    done

    gosu postgres pg_ctl -D "$PGDATA" -w stop
  fi

  exec gosu postgres "$@"
fi

exec "$@"
