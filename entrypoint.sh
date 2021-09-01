#! /bin/bash
echo "MultiVersion 21.09 | github.com/MultiVersion"

if [[ ! -f nginx.conf ]]; then
  cp /opt/nginx.conf /home/container/nginx.conf
fi

if [[ ! -d /home/container/logs ]]; then
  mkdir -p /home/container/logs
fi

sed -i "s/changemyport/$SERVER_PORT/g" /home/container/nginx.conf

nginx -g "daemon off;"
exit 1