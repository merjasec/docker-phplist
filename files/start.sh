#!/bin/bash

/set_server.sh

/usr/sbin/service syslog-ng start
/usr/sbin/service mysql start

/usr/bin/mysqlcheck -c -u root --all-databases

/usr/sbin/service apache2 start
/usr/sbin/service postfix start
/usr/sbin/service cron start

/bin/bash
