FROM alpine AS build

RUN \
  apk add --update openssl-dev wget zlib zlib-dev gcc g++ make && \
  wget https://nginx.org/download/nginx-1.21.0.tar.gz && \
  tar -xzvf nginx-1.21.0.tar.gz && \
  cd nginx-1.21.0 && \
  ./configure --prefix=/home/container --modules-path=/home/container/modules --with-http_ssl_module --with-http_v2_module --with-http_mp4_module --with-debug --conf-path=/home/container/nginx.conf --error-log-path=/home/container/error.log --pid-path=/home/container/nginx.pid --user=container --sbin-path=/usr/sbin/nginx --without-pcre --without-http_rewrite_module && \
  make && \
  make install

FROM alpine
LABEL org.opencontainers.image.source="https://github.com/MultiVersion/nginx" org.opencontainers.image.source="https://multiversion.dviih.technology/" org.opencontainers.image.version="21.09" org.opencontainers.image.revision="LTS" org.opencontainers.image.authors="Dviih" org.opencontainers.image.licenses="unlicense.org"

COPY --from=build /usr/sbin/nginx /usr/sbin/nginx
ADD ./nginx.conf /opt/nginx.conf
ADD ./entrypoint.sh /entrypoint.sh

RUN adduser --disabled-password --home /home/container container
USER container
ENV  USER=container HOME=/home/container PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/ash","/entrypoint.sh"]