# Docker Postgres 8

[![Docker Automated Build](https://img.shields.io/docker/automated/foundryai/postgres8.svg)](https://hub.docker.com/r/foundryai/postgres8/)

This is a docker image used to run a Postgres version 8 docker image for local testing. Ideally to be used with docker-compose.

**This image is not production-ready. It is for local testing purposes only. Use at your own risk.**

The initial use case for this was to test connecting to an Amazon AWS Redshift cluster.
Redshift runs Postgres version 8.0.2 with some modifications, so images tagged `8.0.2` and `redshift` are provided (`latest` currently pulls `8.0.2`).


| Environment Variable | Default |
|----------------------|---------|
| `POSTGRES_USER` | `postgres` |
| `POSTGRES_PASSWORD` |  |
| `POSTGRES_DATABASE` | `postgres` |
| `PGDATA` | `/usr/local/pgsql/data` (volume) |

Copy this snippet into your `docker-compose.yml` file:

    db:
      image: foundryai/postgres8
      environment:
        POSTGRES_USER: docker
        POSTGRES_PASSWORD: docker
        POSTGRES_DATABASE: docker
      ports:
        - 5432:5432
      volumes:
        - ./data:/usr/local/psql/data

Alternatively, run this command to run the container:

    docker run -p 5432:5432 -e POSTGRES_USER=docker -e POSTGRES_PASSWORD=docker -e POSTGRES_DATABASE=docker foundryai/postgres8

## Credits

This image is based on [Patrick Menlove's `docker-postgres8`](https://github.com/pm990320/docker-postgres8)
