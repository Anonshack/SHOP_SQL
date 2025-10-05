FROM postgres:15

ENV POSTGRES_USER=shop_user
ENV POSTGRES_PASSWORD=shop_pass
ENV POSTGRES_DB=shopdb

COPY ./sql /docker-entrypoint-initdb.d/
