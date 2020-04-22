FROM alpine:latest

RUN apk add --no-cache --update \
    php7-cli \
    php7-mysqli \
    php7-ctype \
    php7-xml \
    php7-gd \
    php7-zlib \
    php7-openssl \
    php7-curl \
    php7-opcache \
    php7-json \
    php7-ldap \
    php7-mbstring \
    php7-session \
    curl

ENV VERSION=dokuwiki-2018-04-22b
#https://download.dokuwiki.org/out/dokuwiki-e649a9f2e43939e2a740acf899c5f776.tgz

# download dokuwiki
RUN curl -L -o tmp.tar.gz http://download.dokuwiki.org/src/dokuwiki/$VERSION.tgz \
    && tar xz -C / -f tmp.tar.gz \
    && rm -f tmp.tar.gz \
    && mv /dokuwiki* /dokuwiki \
    && mkdir /dokuwiki-data /dokuwiki-conf \
    && cp -r /dokuwiki/data/* /dokuwiki-data/ \
    && cp -r /dokuwiki/conf/* /dokuwiki-conf/

# create preload.php
COPY ./preload.php /dokuwiki/inc/preload.php

# add savedir option to local configuration
# create ACLs
# create default users - admin:admin
COPY ./conf/ /dokuwiki-conf/

WORKDIR /dokuwiki
EXPOSE 80
VOLUME ["/dokuwiki-data", "/dokuwiki-conf"]
CMD php -S 0.0.0.0:80 -t /dokuwiki/

LABEL de.uniba.ktr.cadvisor.version=$VERSION \
      de.uniba.ktr.cadvisor.name="Dokuwiki" \
      de.uniba.ktr.cadvisor.docker.cmd="docker run --publish=80:80 --detach=true --name=dokuwiki unibaktr/dokuwiki" \
      de.uniba.ktr.cadvisor.vendor="Marcel Grossmann" \
      de.uniba.ktr.cadvisor.architecture=$TARGETPLATFORM \
      de.uniba.ktr.cadvisor.vcs-ref=$VCS_REF \
      de.uniba.ktr.cadvisor.vcs-url=$VCS_URL \
      de.uniba.ktr.cadvisor.build-date=$BUILD_DATE
