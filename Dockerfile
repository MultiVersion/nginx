FROM ubuntu:focal AS build

RUN \
  apt-get update && \
  apt-get install -y libssl-dev wget liblz-dev libpcre3 zlib1g zlib1g-dev gcc g++ make libpcre3 libpcre3-dev && \
  wget https://nginx.org/download/nginx-1.21.2.tar.gz && \
  tar -xzvf nginx-1.21.2.tar.gz && \
  cd nginx-1.21.2 && \
  ./configure --prefix=/home/container --modules-path=/home/container/modules --with-http_ssl_module --with-http_v2_module --with-http_mp4_module --with-debug --conf-path=/home/container/nginx.conf --error-log-path=/home/container/error.log --pid-path=/home/container/nginx.pid --user=container --sbin-path=/usr/sbin/nginx && \
  make && \
  make install

FROM multiversiond/php
LABEL org.opencontainers.image.source="https://github.com/MultiVersion/nginx" org.opencontainers.image.source="https://multiversion.dviih.technology/" org.opencontainers.image.version="21.09" org.opencontainers.image.revision="LTS" org.opencontainers.image.authors="Dviih" org.opencontainers.image.licenses="unlicense.org"

COPY --from=build /usr/sbin/nginx /usr/sbin/nginx
ADD ./nginx.conf /opt/nginx.conf
ADD ./entrypoint.sh /entrypoint.sh

RUN adduser --disabled-password --home /home/container container
USER container
ENV  USER=container HOME=/home/container PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/bash","/entrypoint.sh"]