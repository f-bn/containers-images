ARG PG_RELEASE=16.2

FROM docker.io/postgres:${PG_RELEASE}

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

LABEL \
  org.opencontainers.image.title="postgresql" \
  org.opencontainers.image.source="https://github.com/f-bn/containers-images/postgresql" \
  org.opencontainers.image.description="Custom PostgreSQL ${PG_MAJOR} image with additional extensions, configuration and tools for learning and testing purposes" \
  org.opencontainers.image.licenses="PostgreSQL" \
  org.opencontainers.image.authors="Florian Bobin <contact@fbobin.me>"