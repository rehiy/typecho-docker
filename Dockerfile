FROM rehiy/webox:nginx-php8.5

LABEL version="1.5.0" \
      maintainer="wang@rehiy.com"

ADD initfs /tmp
RUN sh /tmp/deploy

ENTRYPOINT ["/sbin/init"]

EXPOSE 80 443
