FROM postgres:15

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=your_password
ENV POSTGRES_DB=online_shop

COPY ./sql /docker-entrypoint-initdb.d/
