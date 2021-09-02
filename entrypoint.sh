#! /bin/bash
cd /home/container
echo "MultiVersion 21.09 | github.com/MultiVersion"

if [[ ! -f /home/container/nginx.conf ]]; then
  cp /opt/nginx.conf /home/container/nginx.conf
fi

if [[ ! -f /home/container/php-fpm.conf ]]; then
  cp /opt/php-fpm.conf /home/container/php-fpm.conf
fi

if [[ ! -f /home/container/www.conf ]]; then
  cp /opt/www.conf /home/container/www.conf
fi

if [[ ! -d /home/container/logs ]]; then
  mkdir -p /home/container/logs
fi

sed -i "s/changemyport/$SERVER_PORT/g" /home/container/nginx.conf

php-fpm8.0 -p /home/container -y /home/container/php-fpm.conf -D
nginx -g "daemon off;"
exit 1