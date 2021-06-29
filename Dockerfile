FROM ubuntu:20.04

MAINTAINER Gasper Furman <gasper.furman@gf.si>

ENV DEBIAN_FRONTEND noninteractive

ENV TZ 'Europe/Ljubljana'
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata 

RUN apt-get -y install joe nmap vim apt-utils

RUN apt-get -y install apache2 php7.4 libapache2-mod-php7.4  php7.4-mysql php7.4-zip php7.4-curl php7.4-imap php7.4-curl php7.4-mbstring php7.4-xml php7.4-json php7.4-gd mariadb-server mariadb-client

RUN apt-get install -y syslog-ng

RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
RUN debconf-set-selections preseed.txt
RUN apt-get -y install postfix
COPY files/main.cf /etc/postfix/main.cf

RUN apt-get clean

COPY files/* /

RUN chmod +x /*sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
