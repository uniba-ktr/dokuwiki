FROM alpine:latest
ARG VERSION=dokuwiki-2018-04-22b
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL

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
VOLUME ["/dokuwiki"]
CMD php -S 0.0.0.0:80 -t /dokuwiki/

LABEL de.uniba.ktr.dokuwiki.version=$VERSION \
      de.uniba.ktr.dokuwiki.name="Dokuwiki" \
      de.uniba.ktr.dokuwiki.docker.cmd="docker run --publish=80:80 --detach=true --name=dokuwiki unibaktr/dokuwiki" \
      de.uniba.ktr.dokuwiki.vendor="Marcel Grossmann" \
      de.uniba.ktr.dokuwiki.architecture=$TARGETPLATFORM \
      de.uniba.ktr.dokuwiki.vcs-ref=$VCS_REF \
      de.uniba.ktr.dokuwiki.vcs-url=$VCS_URL \
      de.uniba.ktr.dokuwiki.build-date=$BUILD_DATE
