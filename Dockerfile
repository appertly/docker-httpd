FROM httpd:latest

ADD start.sh /scripts/start.sh
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends ca-certificates \
    wget tar g++ make zlib1g zlib1g-dev \
    build-essential build-essential libreadline-gplv2-dev \
    libncursesw5-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libssl-dev \
    && chmod +x /scripts/start.sh 

RUN wget https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tgz \
    && tar xvf Python-3.6.0.tgz \
    && cd Python-3.6.0 \
    && ./configure --enable-shared --prefix=/usr LDFLAGS=-Wl,-rpath=/usr/lib \
    && make install 

RUN cd /usr/bin \
    && python3.6 -m pip install --upgrade pip \
    && pip install mod_wsgi \
    && mod_wsgi-express module-config \
    && pip install django

COPY httpd.conf /usr/local/apache2/conf
COPY httpd-ssl.conf /usr/local/apache2/conf/extra

EXPOSE 443
CMD ["/scripts/start.sh"]
