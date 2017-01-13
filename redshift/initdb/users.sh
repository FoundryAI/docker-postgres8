#!/bin/bash
set -e

gosu postgres psql -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE USER rdsdb;
EOSQL
