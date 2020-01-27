FROM mysql:8.0

COPY ./sql_scripts/ /docker-entrypoint-initdb.d/