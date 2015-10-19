#!/bin/bash

NAME=""
PORT="80"
FQDN="localhost"
CREATE=false
SRV="/srv/http"

function usage {
    cat<<EOT
Usage:
--------------------------------------------------------------------------------
`basename $0` -n laravel -p port -f localhost -c

    -n  Name of the application and of the path (/srv/http/<name>).
    -p  Port of the application. Default value : 80
    -f  Full qualified domain name. Use coma sperated value for multiple FQDN. Default value : localhost
    -c  Create brand new laravel from composer
EOT
}

if [ $# -eq 0 ]; then 
    usage
    exit 1
fi

while getopts ":n:p:f:c" opt; do
    case $opt in
        n)
            NAME=$OPTARG
            ;;
        p)
            PORT=$OPTARG
            ;;
        f)
            FQDN=$OPTARG
            ;;
        c)
            CREATE=true
            ;;
        \?)
            usage >&2
            exit 1
            ;;
        :)
            echo "Option -${OPTARG} requires an argument." >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

echo "Create laravel server"
if [ -f /etc/nginx/sites-enabled/default ]; then 
    echo "Removing default nginx site"
    \rm -f /etc/nginx/sites-enabled/default
fi

mkdir -p ${SRV}/${NAME}

sed -e "s#%PORT%#${PORT}#g" \
    -e "s#%PATH%#${SRV}/${NAME}#g" \
    -e "s#%FQDN%#${FQDN//,/ }#g" /opt/install/sample.conf > /etc/nginx/sites-available/${NAME}.conf

cd /etc/nginx/sites-enabled
ln -s ../sites-available/${NAME}.conf ${NAME}


if [ "$CREATE" == "true" ]; then 
    cd /srv/http
    composer create-project laravel/laravel ${NAME} --prefer-dist
    cd ${NAME}
    npm install .
fi

mkdir -p "${SRV}/${NAME}/public/storage/logs"

/etc/init.d/php5-fpm restart
/etc/init.d/nginx restart
