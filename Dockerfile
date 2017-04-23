FROM debian:jessie
MAINTAINER Derek Vance <dvance@cerb-tech.com>

VOLUME /data

RUN apt-get update && apt-get -y install wget
RUN echo "deb [arch=amd64] http://repo.powerdns.com/debian jessie-auth-master main" > /etc/apt/sources.list.d/pdns.list

RUN echo "Package: pdns-*" >> /etc/apt/preferences.d/pdns
RUN echo "Pin: origin repo.powerdns.com" >> /etc/apt/preferences.d/pdns
RUN echo "Pin-Priority: 600" >> /etc/apt/preferences.d/pdns

RUN wget https://repo.powerdns.com/CBC8B383-pub.asc && \
    apt-key add CBC8B383-pub.asc && \
    rm CBC8B383-pub.asc

RUN apt-get update
RUN apt-get -y install pdns-server pdns-backend-sqlite3 sqlite3

RUN echo "launch=gsqlite3" >> /etc/powerdns/pdns.conf
RUN echo "gsqlite3-database=/data/powerdns.db" >> /etc/powerdns/pdns.conf
RUN echo "gsqlite3-dnssec=yes" >> /etc/powerdns/pdns.conf

COPY schema.sql /data
RUN sqlite /data/powerdns.db < /data/schema.sql

EXPOSE 53
EXPOSE 53/udp
EXPOSE 53000
EXPOSE 8081

ENTRYPOINT ["/usr/sbin/pdns_server", "--daemon=no"]
