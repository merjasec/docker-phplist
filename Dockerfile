FROM ubuntu:18.04

MAINTAINER Gasper Furman <gasper.furman@gf.si>

ENV DEBIAN_FRONTEND noninteractive

ENV TZ 'Europe/Ljubljana'
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata 

RUN apt-get -y install joe nmap vim 

RUN apt-get -y install apache2 php7.2 libapache2-mod-php7.2  php7.2-mysql php7.2-zip mariadb-server mariadb-client

RUN apt-get install -y syslog-ng

RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
RUN echo "postfix postfix/mailname string $HOSTNAME" >> preseed.txt
RUN debconf-set-selections preseed.txt
RUN apt-get -y install postfix

RUN apt-get clean

COPY files/* /

RUN chmod +x /*sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
