# FROM andrewmichaelsmith/docker-heartbleed :
FROM astral1/raring

RUN apt-get update
RUN apt-get install -y apache2

RUN mkdir /etc/apache2/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"  

ADD default-ssl /etc/apache2/sites-available/default-ssl

RUN a2enmod ssl
RUN a2ensite default-ssl

EXPOSE 443

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
#########################################################

RUN apt-get install -y iputils-ping net-tools iproute

# enable SSL
RUN a2enmod ssl

# Restart Apache to apply changes
RUN service apache2 restart

