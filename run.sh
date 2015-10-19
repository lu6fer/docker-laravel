#!/bin/bash 

FLOW=/var/cache/laravel-install/

if [ -f "${FLOW}/03-server" ]; then
    echo "Start ssh server"
    /etc/init.d/sshd start

    echo "Start mariadb"
    /etc/init.d/mysql start

    echo "Start php5-fpm"
    /etc/init.d/php5-fpm start

    echo "Start nginx"
    /etc/init.d/nginx start

    tail -f /var/log/nginx/* /var/log/php5-fpm.log
fi
