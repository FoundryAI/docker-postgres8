FROM foundryai/postgres8:8.0.2

COPY ./initdb /docker-entrypoint-initdb.d/

CMD ["postgres", "pg_ctl", "-w", "start"]
