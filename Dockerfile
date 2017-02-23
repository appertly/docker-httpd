FROM httpd:latest

ADD start.sh /scripts/start.sh
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/apt/* \
    && rm -rf /var/log/dpkg.log \
    && rm -rf /var/log/bootstrap.log \
    && rm -rf /var/log/alternatives.log \
    && chmod +x /scripts/start.sh

COPY httpd.conf /usr/local/apache2/conf
COPY httpd-ssl.conf /usr/local/apache2/conf/extra

EXPOSE 443
CMD ["/scripts/start.sh"]
