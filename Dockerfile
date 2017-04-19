FROM debian:jessie
MAINTAINER Derek Vance <dvance@cerb-tech.com>

RUN apt-get update

RUN apt-get -y install pdns-server