#!/bin/bash

PHPLISTVER="3.6.8"

if [ -d /var/www/html/lists ]
then

        date=$(/usr/bin/date +"%Y-%m-%d_%H-%M-%S")
        /usr/bin/mysqldump phplist  > /backup/phplist-$date.sql

        cp -a /var/www/html/lists/config /backup/phplist-config-$date

        # wget https://sourceforge.net/projects/phplist/files/phplist/$PHPLISTVER/phplist-$PHPLISTVER.tgz/download -O phplist-$PHPLISTVER.tgz
        cd /tmp && /usr/bin/tar xvfz /phplist-$PHPLISTVER.tgz

        cp -r /tmp/phplist-$PHPLISTVER/public_html/lists /var/www/html/

        cp -a /backup/phplist-config-$date/* /var/www/html/lists/config/.

        mkdir -p /var/www/html/lists/uploads && chmod +777 /var/www/html/lists/uploads

fi
