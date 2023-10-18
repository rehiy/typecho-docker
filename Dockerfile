FROM rehiy/webox:nginx-php8

LABEL version="1.2.1" \
      maintainer="wang@rehiy.com"

ADD initfs /tmp
RUN sh /tmp/deploy

ENTRYPOINT ["/sbin/init"]

EXPOSE 80 443
