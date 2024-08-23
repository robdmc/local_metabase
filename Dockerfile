FROM python:3.10
# FROM python:3.8.12  This was original python version.  Updated to above, but needs testing.

WORKDIR /app
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEV_MODE=FALSE
ENV PYTHONPATH "/code"


RUN apt-get update
RUN apt-get install -y lsb-release
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-15

RUN ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime

RUN apt-get update && \
    apt-get install -y vim && \
    apt-get install -y locales locales-all && \
    apt-get install -y cmake

RUN pip install -U pip && \
    pip install click && \
    pip install pandas && \
    pip install easier && \
    pip install click && \
    pip install duckdb
