# docker-phplist
Docker image for the mailing list phplist (3.6.6) based on ubuntu 20.04 with php7.4, apache, mariadb and postfix. https://www.phplist.org

# Usage:
```sh
docker run --name=my-merjasec-phplist \
    -it -d \
    --dns=8.8.8.8 --dns=8.8.4.4 \
    -h list.gf.si \
    -p 8080:80 \
    -v /home/list/phplist/html:/var/www/html \
    -v /home/list/phplist/mysql:/var/lib/mysql \
    -v /home/list/phplist/backup:/backup \
    -e "MYSQLUSER=phplist" -e "MYSQLPASS=phplist" -e "MYSQLDB=phplist" \
    -e "MYSQLHOST=localhost" -e "MYSQLROOTPASS=Pa5sw0rd" \
    -e "LANG=sl" \
    merjasec/phplist:latest
```

Go to http://localhost:8080/lists/admin to setup phplist

# Upgrade: 
```sh
docker exec -it my-merjasec-phplist /upgrade.sh
```

Go to http://localhost:8080/lists/admin to complete the upgrade process

https://hub.docker.com/r/merjasec/phplist/

