FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install build-essential libreadline6 libreadline6-dev zlib1g-dev vim wget

RUN mkdir /downloads && \
    cd /downloads && \
    wget https://ftp.postgresql.org/pub/source/v8.0.2/postgresql-8.0.2.tar.gz && \
    tar -xzf postgresql-8.0.2.tar.gz && \
    rm postgresql-8.0.2.tar.gz && \
    cd postgresql-8.0.2 && \
    ./configure && \
    make && \
    make install && \
    adduser postgres && \
    mkdir /usr/local/pgsql/data && \
    chown postgres /usr/local/pgsql/data && \
    rm -rf /downloads

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh && \
    chown postgres /docker-entrypoint.sh

USER postgres
RUN ./usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data

COPY ./postgresql.conf ./pg_hba.conf /usr/local/pgsql/data/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ./usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data
