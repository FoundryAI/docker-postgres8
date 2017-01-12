FROM foundryai/postgres8:8.0.2

RUN /usr/local/pgsql/bin/pg_ctl -D ./usr/local/pgsql/data -w start && \
    /usr/local/pgsql/bin/psql -U postgres -c "CREATE USER rdsdb;" && \
    /usr/local/pgsql/bin/pg_ctl -D ./usr/local/pgsql/data stop

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["./usr/local/pgsql/bin/postmaster", "-D", "/usr/local/pgsql/data"]
