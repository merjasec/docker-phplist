#!/bin/bash

PHPLISTVER="3.6.9"

if [ -z $MYSQLHOST ]; then MYSQLHOST="localhost"; fi
if [ -z $MYSQLUSER ]; then MYSQLUSER="phplist"; fi
if [ -z $MYSQPASS ]; then MYSQLPASS="phplist"; fi
if [ -z $MYSQLDB ]; then MYSQLDB="phplist"; fi
if [ -z $MYSQLROOTPASS ]; then MYSQLROOTPASS="Pa5sw0rd"; fi
if [ -z $LANG ]; then LANG="en"; fi
if [ -z $TZ ]; then TZ="Europe/Ljubljana"; fi


echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata 

echo "myhostname = $HOSTNAME" >> /etc/postfix/main.cf

if [ ! -d /var/lib/mysql/mysql ]
then
        echo "missing mysql data. installing mysql init db"
        /usr/bin/mysql_install_db

        /usr/sbin/service mysql start
        
        echo "GRANT ALL PRIVILEGES ON phplist.* TO '$MYSQLUSER'@'localhost' IDENTIFIED BY '$MYSQLPASS';" | /usr/bin/mysql

	echo "CREATE DATABASE IF NOT EXISTS $MYSQLDB /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;" | /usr/bin/mysql

fi


if [ ! -f /var/www/html/index.html ]
then
	echo '<meta http-equiv="refresh" content="0; url=/lists" />' > /var/www/html/index.html
fi

#todo if:
sed -i 's/DirectoryIndex\ /DirectoryIndex\ index.php\ /g' /etc/apache2/mods-enabled/dir.conf

if [ ! -d /var/www/html/lists ]
then
	# wget https://sourceforge.net/projects/phplist/files/phplist/$PHPLISTVER/phplist-$PHPLISTVER.tgz/download -O phplist-$PHPLISTVER.tgz
	cd / && tar xvfz /phplist-$PHPLISTVER.tgz
	mv /phplist-$PHPLISTVER/public_html/lists /var/www/html/lists


	#config.php
 	sed -i 's/$database_host/$database_host="'$MYSQLHOST'";#/g' /var/www/html/lists/config/config.php
	sed -i 's/$database_user/$database_user="'$MYSQLUSER'";#/g' /var/www/html/lists/config/config.php
	sed -i 's/$database_name/$database_name="'$MYSQLDB'";#/g' /var/www/html/lists/config/config.php
	sed -i 's/$database_password/$database_password="'$MYSQLPASS'";#/g' /var/www/html/lists/config/config.php


	#hack
	sed -i 's/TEST/OLD_TEST/g' /var/www/html/lists/config/config.php
	echo "define('TEST', 0);" >> /var/www/html/lists/config/config.php
	#/hack
	echo "define('UPLOADIMAGES_DIR', 'lists/uploads');" >> /var/www/html/lists/config/config.php
	echo "\$default_system_language = \"$LANG\";" >> /var/www/html/lists/config/config.php
	#/config.php

	mkdir -p /var/www/html/lists/uploads && chmod +777 /var/www/html/lists/uploads
fi

if [ ! -f /var/spool/cron/crontabs/root ]
then
        echo "Setting default crontab"
        /usr/bin/crontab -u root /crontab.default
fi


/usr/bin/newaliases
