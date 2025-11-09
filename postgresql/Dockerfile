ARG VERSION=18.0

FROM docker.io/postgres:${VERSION}

RUN mkdir -p /etc/postgresql/config.d ;

RUN set -ex ; \
  export DEBIAN_FRONTEND=noninteractive ; \
  apt update ; \
  apt install -y --no-install-recommends \
    postgresql-${PG_MAJOR}-pgaudit \
    postgresql-${PG_MAJOR}-cron \
    postgresql-${PG_MAJOR}-repack \
    postgresql-${PG_MAJOR}-partman \
    postgresql-${PG_MAJOR}-pg-qualstats \
    postgresql-${PG_MAJOR}-pgvector \
    postgresql-${PG_MAJOR}-pg-stat-kcache \
    pgbackrest \
    pg-activity \
    procps \
    lsof \
    less ; \
  apt clean all ; \
  rm -rf /var/lib/apt/lists/*

COPY postgresql.default.conf /etc/postgresql/postgresql.conf

CMD [ "postgres", "-c", "config_file=/etc/postgresql/postgresql.conf" ]