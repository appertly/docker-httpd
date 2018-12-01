#!/bin/bash

FPM_PORT_9000_TCP_ADDR="${FPM_PORT_9000_TCP_ADDR:-fpm}"
sed -i "s/%fpm-ip%/$FPM_PORT_9000_TCP_ADDR/" /usr/local/apache2/conf/httpd.conf

if [ -e "$HTTPD_DOCUMENT_ROOT" ]
then
    sed -i "s:/usr/local/apache2/htdocs:$HTTPD_DOCUMENT_ROOT:g" /usr/local/apache2/conf/httpd.conf
fi

if [ ! -e "/usr/local/apache2/conf/dhparam.pem" ]
then
  openssl dhparam -out "/usr/local/apache2/conf/dhparam.pem" 2048 2>/dev/null
fi

if [ ! -e "/usr/local/apache2/conf/server.crt" ] || [ ! -e "/usr/local/apache2/conf/server.key" ]
then
  openssl req -x509 -newkey rsa:4096 \
    -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=$HOSTNAME" \
    -keyout "/usr/local/apache2/conf/server.key" \
    -out "/usr/local/apache2/conf/server.crt" \
    -days 3650 -nodes -sha256 2>/dev/null
fi

update-ca-certificates 2>/dev/null

set -e

mkdir /var/log/apache2
chown www-data:www-data /var/log/apache2
cd /app
    chown -R www-data:www-data ./
    chmod -R +x ./
    pip install -r requirements.txt 
    python3.6 manage.py makemigrations
    python3.6 manage.py migrate
    python3.6 manage.py collectstatic --no-input
cd /static 
    chown -R www-data:www-data ./
    chmod -R +x ./
if [ ! -d /app/media/posts || ! -d /app/media/events ]
then 
    mkdir -p /app/media/posts
    mkdir -p /app/media/events
fi 
cd /app/media
    chown -R www-data:www-data ./
    chmod -R +x ./
cd /app

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

exec httpd -DFOREGROUND
