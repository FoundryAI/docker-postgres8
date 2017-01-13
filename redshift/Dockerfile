FROM foundryai/postgres8:8.0.2

COPY ./initdb /docker-entrypoint-initdb.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["postmaster"]
