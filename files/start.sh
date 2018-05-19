#!/bin/bash

/set_server.sh

/usr/sbin/service syslog-ng start
/usr/sbin/service mysql start
/usr/sbin/service apache2 start
/usr/sbin/service postfix start

/bin/bash
