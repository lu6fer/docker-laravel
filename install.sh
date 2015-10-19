#!/bin/bash

LOG=/var/log/install-docker.log
FLOW=/var/cache/laravel-install/

export DEBIAN_FRONTEND=noninteractive

# Update debian
if [ ! -f "${FLOW}/00-update" ]; then
    echo "Update debian" | tee -a ${LOG}
    apt-get -y install apt-utils 2>&1 1>>$LOG
    apt-get update 2>&1 1>>$LOG ; apt-get dist-upgrade -y 2>&1 1>>$LOG
    touch "${FLOW}/00-update"
fi

# Install requirements
if [ ! -f "${FLOW}/01-requirements" ]; then 
    echo "install nginx, php-fpm, mariadb" | tee -a ${LOG}
    debconf-set-selections /opt/install/maria-password.txt
    apt-get -y install mysql-server nginx php5-fpm php5-cli php5-mysql php5-mcrypt openssh-server 2>&1 1>>$LOG
    mkdir -p /var/run/sshd 
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
    sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
    touch "${FLOW}/01-requirements"
fi

# Install utils
if [ ! -f "${FLOW}/02-utils" ]; then 
    echo "Install utils (composer, npm, vim)" | tee -a ${LOG}
    apt-get -y install curl 2>&1 1>>$LOG
    # Latest nodejs version
    curl -sL https://deb.nodesource.com/setup_4.x | bash - 2>&1 1>>$LOG
    apt-get -y install nodejs vim 2>&1 1>>$LOG
    curl -sS https://getcomposer.org/installer | php 2>&1 1>>$LOG
    mv composer.phar /usr/local/bin/composer 2>&1 1>>$LOG
    # enable mcrypt
    php5enmod mcrypt 2>&1 1>>$LOG
    # install gulp, bower, grunt
    npm install -g bower 2>&1 1>>$LOG
    npm install -g gulp 2>&1 1>>$LOG
    npm install -g grunt-cli 2>&1 1>>$LOG
    touch "${FLOW}/02-utils"
fi

# Allow server to run
if [ ! -f "${FLOW}/03-server" ]; then 
    touch "${FLOW}/03-server"
fi

