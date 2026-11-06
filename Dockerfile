FROM ubuntu:26.04

MAINTAINER Gasper Furman <gasper.furman@gf.si>

ENV DEBIAN_FRONTEND noninteractive

ENV TZ 'Europe/Ljubljana'
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata 

RUN apt-get -y install joe nmap vim apt-utils

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb \
 && dpkg -i /tmp/debsuryorg-archive-keyring.deb \
 && rm /tmp/debsuryorg-archive-keyring.deb \
 && . /etc/os-release \
 && printf '%s\n' \
      'Types: deb' \
      'URIs: https://packages.sury.org/php/' \
      "Suites: ${VERSION_CODENAME}" \
      'Components: main' \
      'Signed-By: /usr/share/keyrings/debsuryorg-archive-keyring.gpg' \
      > /etc/apt/sources.list.d/sury-php.sources \
 && apt-get update
 
#RUN apt-get -y install apache2 php7.4 libapache2-mod-php7.4  php7.4-mysql php7.4-zip php7.4-curl php7.4-imap php7.4-curl php7.4-mbstring php7.4-xml php7.4-json php7.4-gd mariadb-server mariadb-client
RUN apt-get -y install apache2 php8.5 libapache2-mod-php8.5 php8.5-mysql php8.5-zip php8.5-curl php8.5-xml php8.5-mbstring  php8.5-gd php8.5-curl mariadb-server mariadb-client

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
