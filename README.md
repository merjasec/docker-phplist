# docker-phplist
Docker image for the mailing list phplist (3.3.3) based on ubuntu 18.04 with php7.2, apache, mariadb and postfix. https://www.phplist.org

# Usage:
```sh
docker run --name=my-merjasec-phplist \
    -it -d \
    --dns=8.8.8.8 --dns=8.8.4.4 \
    -h list.gf.si \
    -p 8080:80 \
    -v /home/list/phplist/html:/var/www/html \
    -v /home/list/phplist/mysql:/var/lib/mysql \
    -e "MYSQLUSER=phplist" -e "MYSQLPASS=phplist" -e "MYSQLDB=phplist" \
    -e "MYSQLROOTPASS=Pa5sw0rd" \
    -e "LANG=sl" \
    merjasec/phplist:latest
```

# docker-phplist
Docker image for the mailing list phplist (3.3.3) based on ubuntu 18.04 with php7.2, apache, mariadb and postfix. https://www.phplist.org

Go to http://localhost:8080/lists/admin to setup phplist

