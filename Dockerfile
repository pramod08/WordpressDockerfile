FROM ubuntu:14.04

MAINTAINER Bizruntime@pramod


# Install plugins
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y wget curl python  && \
apt-get install -y nano  php5 libapache2-mod-php5 php5-mysql php5-curl php5-gd php5-intl php-pear && \
apt-get -y install php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite && \
apt-get install -y php5-tidy php5-xmlrpc php5-xsl && \
apt-get install -y git openssl  && apt-get install -y supervisor

RUN a2enmod ssl


RUN mkdir /etc/apache2/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key \
    -out /etc/apache2/ssl/apache.crt \
	-subj "/C=IN/ST=KARNATAKA/L=BANGALORE/OU=BIZRUNTIME/O=WordPressDev/CN=infra"  


ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

RUN a2ensite  default-ssl.conf

ADD dir.conf  /etc/apache2/mods-enabled/dir.conf
ADD 000-default.conf  /etc/apache2/sites-available/000-default.conf
ADD apachesupervisor.conf /etc/supervisor/conf.d/apachesupervisor.conf


# Download Wordpress from git into /opt
RUN  git clone  https://github.com/pramod08/Wordpress.git  /opt

# Configure Wordpress to connect to local DB
ADD wp-config.php /opt/wp-config.php

# Modify permissions to allow plugin upload
RUN cp -R /opt/* /var/www/html/
RUN chown -R www-data:www-data  /var/www/html
RUN chmod -R 755 /var/www/html/
ADD run.sh /run.sh
RUN chmod +x /*.sh

EXPOSE 80 3306 443
CMD ["/run.sh"]
