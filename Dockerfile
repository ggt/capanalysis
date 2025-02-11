FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install \
	vim \
	wget \
	curl \
	php \
	php-common \
	sudo \
	apache2 \
	apt-utils \
	libpq5 \
	libssl1.1 \
	tshark \
	samba \
	libapache2-mod-php \
	php-sqlite3 \
	php-pgsql \
	libgeoip1 \
	sqlite3 \
	postgresql \
	postgresql-client \
	php-mdb2-driver-pgsql \
	libgeoip-dev \
	libndpi-dev \
	libjson-c-dev \
	zip


RUN echo '#!/bin/sh' > /usr/sbin/policy-rc.d \
    && echo 'exit 101' >> /usr/sbin/policy-rc.d \
    && chmod +x /usr/sbin/policy-rc.d

#RUN wget https://sourceforge.net/projects/capanalysis/files/version%201.2.3/capanalysis_1.2.3_amd64.deb/download -O /tmp/capanalysis_1.2.3_amd64.deb

COPY capanalysis_1.2.3_amd64.deb /tmp/

RUN apt-get update && dpkg -i /tmp/capanalysis_1.2.3_amd64.deb

RUN sed -i -e 's/PRIORITY=1 #(0..20)/PRIORITY=0 #(0..20)Z/g' /etc/init.d/capanalysis
RUN sed -i 's/^upload_max_filesize.*/upload_max_filesize\ = 10000M/g' /etc/php/7.2/cli/php.ini /etc/php/7.2/apache2/php.ini /usr/lib/php/7.2/php.ini-production.cli /usr/lib/php/7.2/php.ini-production /usr/lib/php/7.2/php.ini-development 
RUN sed -i 's/^post_max_size.*/post_max_size\ = 10000M/g' /etc/php/7.2/cli/php.ini /etc/php/7.2/apache2/php.ini /usr/lib/php/7.2/php.ini-production.cli /usr/lib/php/7.2/php.ini-production /usr/lib/php/7.2/php.ini-development 
RUN service apache2 restart

CMD sudo service postgresql restart && \
sudo service apache2 restart && \
sudo service capanalysis restart && \
tail -f /var/log/apache2/access.log
