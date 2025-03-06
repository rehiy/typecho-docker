FROM rehiy/webox:nginx-php8.3

LABEL version="1.3.0" \
      maintainer="wang@rehiy.com"

ADD initfs /tmp
RUN sh /tmp/deploy

ENTRYPOINT ["/sbin/init"]

EXPOSE 80 443
