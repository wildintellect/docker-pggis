# PostgreSQL GIS stack
# On Ubuntu 14.04 with Ubuntugis-unstable PPA
# This image includes the following tools
# - PostgreSQL 9.3.x
# - PostGIS 2.1.x
# - GDAL/OGR 1.11.x
#
# Version 0.1
#
# Originally forked from 

FROM phusion/baseimage
MAINTAINER Alex Mandel, tech@wildintellect.com

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


RUN apt-get update && apt-get install -y wget ca-certificates

# Add Ubuntugis-unstable repository
RUN apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable

RUN PG_Version=`apt-cache show postgresql -v |grep Version | awk -F '[: +]' '{print $3}' | head -n 1`
# Update and Install packages
RUN apt-get update && apt-get install --yes \
    postgis \
    "postgresql-$PG_VERSION-postgis-2.1"


# ---------- SETUP --------------

## add a baseimage PostgreSQL init script
#RUN mkdir /etc/service/postgresql
#ADD postgresql.sh /etc/service/postgresql/run

## Adjust PostgreSQL configuration so that remote connections to the
## database are possible. 
#RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.5/main/pg_hba.conf

## And add ``listen_addresses`` to ``/etc/postgresql/9.5/main/postgresql.conf``
#RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf

## Expose PostgreSQL
#EXPOSE 5432

## Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/data", "/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

## add database setup upon image start
#ADD pgpass /root/.pgpass
#RUN chmod 700 /root/.pgpass
#RUN mkdir -p /etc/my_init.d
#ADD init_db_script.sh /etc/my_init.d/init_db_script.sh
#ADD init_db.sh /root/init_db.sh

## ---------- Final cleanup --------------
##
## Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

